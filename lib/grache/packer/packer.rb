# encoding: utf-8

require 'aws-sdk'
require 'digest'
require 'fileutils'
require 'json'
require 'net/http'
require 'tmpdir'
require 'uri'

require 'rubygems'
require 'bundler/cli'

require 'zip'

require_relative '../bundler/bundler'
require_relative '../zip/zip'

module Grache
  class Packer
    GEMFILE_RE = Regexp.new(/^\s*gem\s+['"]([^'"]+)['"]\s*,\s*:git\s+=>\s+['"]([^'"]+)['"](\s*,\s*:branch\s+=>\s+['""]([^'"]+)['""])?$/)

    DEFAULT_INSTALL_OPTIONS = {
    }

    DEFAULT_PACK_OPTIONS = {
      dir: '.'
    }

    DEFAULT_ZIP_OPTIONS = {
    }

    CMDS = {
      # gemfile path
      'bundle-install-no-deployment' => 'bundle install --gemfile=%s --no-deployment',

      'bundle-install-deployment' => 'bundle install --gemfile=%s --deployment',

      # gemfile path
      # deployment path
      'bundle-install-deployment-path' => 'bundle install --gemfile=%s --deployment --path %s',

      # gemfile path
      'bundle-pack' => 'bundle pack --gemfile=%s --all',

      # gemspec path
      'gem-build' => 'gem build %s', # spec path

      'gem-generate-index' => 'gem generate_index'
    }

    class << self
      def exec_cmd(cmd)
        puts cmd
        system(cmd)
      end

      def find_gemfile(path)
        gemfile_path = File.join(path, 'Gemfile')
        return gemfile_path if File.exist?(gemfile_path)

        new_path = File.expand_path(File.join(path, '..'))
        return nil if new_path == path

        find_gemfile(new_path)
      end

      def get_checksum(path)
        content = File.open(path).read
        # TODO: Return checksum here
        content
      end

      def get_gemfile_meta(path)
      end

      def install(opts = DEFAULT_INSTALL_OPTIONS)
        opts = DEFAULT_INSTALL_OPTIONS.merge(opts)

        puts "Installing pack: #{JSON.pretty_generate(opts)}"

        dir = opts[:dir]
        fail ArgumentError, 'No directory specified' unless dir

        dir = File.expand_path(dir)

        gemfile = find_gemfile(dir)
        return unless gemfile

        gem_dir = File.dirname(gemfile)
        vendor_dir = File.join(gem_dir, 'vendor/')

        unless File.directory?(vendor_dir)
          puts "Creating #{vendor_dir}"
          FileUtils.mkdir_p vendor_dir
        end

        FileUtils.rm_rf File.join(vendor_dir, 'cache')

        gemfile_lock = "#{gemfile}.lock"
        sha = Digest::SHA2.file(gemfile_lock).hexdigest

        uri = URI.parse("https://gdc-ms-grache.s3.amazonaws.com/grache-#{sha}.zip")
        puts "Looking for #{uri.to_s}"

        name = uri.path.split('/').last
        FileUtils.rm_rf name if File.exists?(name)

        begin
          Net::HTTP.start(uri.host) do |http|
            resp = http.get(uri.path)
            if(resp.code == '200')
              open(name, 'wb') do |file|
                file.write(resp.body)
              end
            else
              Packer.pack(opts)
              return
            end
          end
        rescue => e
          puts "ERROR: #{e.inspect}"
        end

        Zip::File.open(name) do |zip_file|
          # Handle entries one by one
          zip_file.each do |entry|
            # Extract to file/directory/symlink
            puts "Extracting #{entry.name}"
            out_path = "vendor/#{entry.name}"
            entry.extract(out_path)
          end
        end

        puts "Removing old #{name}"
        FileUtils.rm_rf name
      end

      def pack(opts = DEFAULT_PACK_OPTIONS)
        opts = DEFAULT_PACK_OPTIONS.merge(opts)

        dir = opts[:dir]
        fail ArgumentError, 'No directory specified' unless dir

        dir = File.expand_path(dir)
        puts "Packing #{dir}"

        gemfile = find_gemfile(dir)
        return unless gemfile

        puts "Gemfile located at #{gemfile}" if gemfile
        gem_dir = File.dirname(gemfile)

        gemfile = process_gemfile(gemfile)

        # exit(0)

        # TODO: Read gemfile programatically
        uses_gemspec = File.open(gemfile).read.index(/^gemspec$/) != nil
        if(uses_gemspec)
          tmp = File.join(gem_dir, '.gemspec')
          gemspecfile = tmp if File.exist?(tmp)
          gemspecfile = Dir.glob('*.gemspec').first if gemspecfile.nil?
        end

        gemfile_lock = "#{gemfile}.lock"
        unless File.exists?(gemfile_lock)
          cmd = CMDS['bundle-install-no-deployment'] % [gemfile]
          exec_cmd(cmd)
        end

        if uses_gemspec
          cmd = CMDS['gem-build'] % gemspecfile
          exec_cmd(cmd)
        end

        cache_dir = File.join(gem_dir, 'vendor', 'cache')
        gems_dir = File.join(gem_dir, 'vendor', 'gems')

        # Delete cache directory
        if File.directory?(cache_dir)
          puts "Deleting cache #{cache_dir}"
          FileUtils.rm_rf cache_dir
        end

        FileUtils.mkdir_p cache_dir

        # Move built gems to cache
        Dir.glob("#{gems_dir}/**/*.gem").each do |gem|
          dest = File.join(cache_dir, File.basename(gem))
          puts "Moving #{gem} -> #{dest}"
          FileUtils.mv(gem, dest)
        end

        # Pack gems
        cmd = CMDS['bundle-pack'] % gemfile
        exec_cmd(cmd)

        # Generate local gem index, see http://stackoverflow.com/questions/5633939/how-do-i-specify-local-gem-files-in-my-gemfile
        # Dir.chdir(cache_dir) do
        #   # Pack gems
        #   cmd = CMDS['gem-generate-index'] % gemfile
        #   exec_cmd(cmd)
        # end
      end

      def process_gemfile(gemfile_path)
        new_gemfile = ''
        git_gems = {}
        File.open(gemfile_path, 'r') do |f|
          f.each_line do |l|
            m = GEMFILE_RE.match(l)
            if(m)
              branch = m[4] || 'master'
              new_gemfile += "gem '#{m[1]}',  :path => './vendor/gems/#{m[1]}'\n"
              git_gems[m[1]] = {
                :branch => branch,
                :git => m[2]
              }
            else
              new_gemfile += l
            end
          end
        end
        puts new_gemfile

        gem_dir = File.join(File.dirname(gemfile_path), 'vendor', 'gems')
        FileUtils.mkdir_p gem_dir
        Dir.chdir(gem_dir) do
          git_gems.each do |name, gem|
            FileUtils.rm_rf(name)
            cmd = "git clone #{gem[:git]} #{name}"
            puts cmd
            system cmd

            Dir.chdir(name) do
              cmd = "git checkout #{gem[:branch]}"
              puts cmd
              system cmd

              cmd = "gem build *.gemspec"
              system(cmd)
            end
          end
        end

        new_gemfile_path = "#{gemfile_path}.Generated"
        File.open(new_gemfile_path, 'w') { |file| file.write(new_gemfile) }
        new_gemfile_path
      end

      def zip(opts = DEFAULT_ZIP_OPTIONS)
        opts = DEFAULT_ZIP_OPTIONS.merge(opts)

        puts "Zipping pack: #{JSON.pretty_generate(opts)}"

        dir = opts[:dir]
        fail ArgumentError, 'No directory specified' unless dir

        dir = File.expand_path(dir)
        puts "Zipping #{dir}"

        gemfile = find_gemfile(dir)
        return unless gemfile

        gem_dir = File.dirname(gemfile)
        gems_dir = File.join(gem_dir, 'gems')
        vendor_dir = File.join(gem_dir, 'vendor')

        unless File.directory?(vendor_dir)
          puts "Vendor directory does not exists. Run 'grache pack build' first!"
          return
        end

        gemfile_lock = "#{gemfile}.lock"
        sha = Digest::SHA2.file(gemfile_lock).hexdigest

        archive = "grache-#{sha}.zip"
        FileUtils.rm archive, :force => true

        # ZipGenerator.new(gems_dir, archive).write
        ZipGenerator.new(vendor_dir, archive).write

        puts "Created #{archive}"
      end
    end


    def deploy(opts = {access_key_id: nil, secret_access_key: nil})
      bucket_name = 'gdc-ms-grache'

      access_key_id = opts[:access_key_id]
      if access_key_id.nil?
        print 'Access Key ID? '
        access_key_id = $stdin.gets.chomp
      end

      secret_access_key = opts[:secret_access_key]
      if secret_access_key.nil?
        print 'Secret access key? '
        secret_access_key = $stdin.gets.chomp
      end

      s3 = AWS::S3.new(:access_key_id => access_key_id, :secret_access_key => secret_access_key)

      Dir.glob("**/grache-*.zip").each do |grache_file|
        key = File.basename(grache_file)
        s3.buckets[bucket_name].objects[key].write(:file => grache_file)
        puts "Uploading file #{grache_file} to bucket #{bucket_name}."
      end
    end

    def find_gemfile(path)
      Packer.find_gemfile(path)
    end

    def get_checksum(path)
      Packer.get_checksum(path)
    end

    def install(opts = DEFAULT_INSTALL_OPTIONS)
      opts = DEFAULT_PACK_OPTIONS.merge(opts)

      Packer.install(opts)
    end

    def pack(opts = DEFAULT_PACK_OPTIONS)
      opts = DEFAULT_PACK_OPTIONS.merge(opts)

      Packer.pack(opts)
    end

    def zip(opts = DEFAULT_ZIP_OPTIONS)
      opts = DEFAULT_PACK_OPTIONS.merge(opts)

      Packer.zip(opts)
    end
  end
end

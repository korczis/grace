# encoding: utf-8

require 'digest'
require 'fileutils'
require 'json'
require 'tmpdir'

require 'rubygems'
require 'bundler/cli'

require 'zip'

require_relative '../bundler/bundler'
require_relative '../zip/zip'

module Grache
  class Packer
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
      'gem-build' => 'gem build %s' # spec path
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
        puts "Zipping #{dir}"

        gemfile = find_gemfile(dir)
        return unless gemfile

        gem_dir = File.dirname(gemfile)
        vendor_dir = File.join(gem_dir, 'vendor/')

        unless File.directory?(vendor_dir)
          FileUtils.mkdir_p vendor_dir
          return
        end

        gemfile_lock = "#{gemfile}.lock"
        sha = Digest::SHA2.file(gemfile_lock).hexdigest

        url = " https://gdc-ms-grache.s3.amazonaws.com/#{sha}.zip"
        puts "Looking for #{url}"
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

        cache_dir = File.join(gem_dir, 'vendor')
        if File.directory?(cache_dir)
          puts "Deleting cache #{cache_dir}"
          FileUtils.rm_rf cache_dir
        end

        cmd = CMDS['bundle-pack'] % gemfile
        exec_cmd(cmd)
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
        vendor_dir = File.join(gem_dir, 'vendor/')

        unless File.directory?(vendor_dir)
          puts "Vendor directory does not exists. Run 'grache pack build' first!"
          return
        end

        gemfile_lock = "#{gemfile}.lock"
        sha = Digest::SHA2.file(gemfile_lock).hexdigest

        archive = "#{sha}.zip"
        FileUtils.rm archive, :force => true

        ZipGenerator.new(vendor_dir, archive).write

        puts "Created #{archive}"
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

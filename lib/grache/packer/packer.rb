# encoding: utf-8

require 'fileutils'
require 'tmpdir'

require 'rubygems'
require 'bundler/cli'

require_relative '../bundler/bundler'

module Grache
  class Packer
    DEFAULT_PACK_OPTIONS = {
      dir: '.'
    }

    CMDS = {
      # gemfile path
      'bundle-install-no-deployment' => 'bundle install --gemfile=%s --no-deployment',

      'bundle-install-deployment' => 'bundle install --gemfile=%s --deployment',

      # gemfile path
      # deployment path
      'bundle-install-deployment-path' => 'bundle install --gemfile=%s --deployment --path %s',

      'bundle-pack' => 'bundle pack --all',

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

        cmd = CMDS['bundle-pack']
        exec_cmd(cmd)

        # cmd = CMDS['bundle-install-deployment'] % [gemfile]
        # exec_cmd(cmd)

        # gems = ::Bundler.rubygems.all_specs

        # Dir.chdir(gem_dir) do
        #   Dir.mktmpdir do |tmp_dir|
        #   end
        # end
      end
    end


    def find_gemfile(path)
      Packer.find_gemfile(path)
    end

    def get_checksum(path)
      Packer.get_checksum(path)
    end

    def pack(opts = DEFAULT_PACK_OPTIONS)
      Packer.pack(opts)
    end
  end
end

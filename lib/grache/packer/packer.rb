# encoding: utf-8

require 'tmpdir'

module Grache
  class Packer
    DEFAULT_PACK_OPTIONS = {
      dir: '.'
    }

    def find_gemfile(path)
      gemfile_path = File.join(path, 'Gemfile')
      return gemfile_path if File.exist?(gemfile_path)

      new_path = File.expand_path(File.join(path, '..'))
      return nil if new_path == path

      find_gemfile(new_path)
    end

    def get_checksum(gemfile)
      content = File.open(gemfile).read
      content
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

      Dir.chdir(gem_dir) do
        Dir.mktmpdir do |tmp_dir|
          cmd = "bundle install --deployment --path #{tmp_dir}"
          puts cmd
          system(cmd)
          42
        end
      end
    end
  end
end

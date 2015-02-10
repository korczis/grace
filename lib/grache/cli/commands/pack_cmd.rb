# encoding: UTF-8

require 'pp'

require_relative '../shared'
require_relative '../../packer/packer'

Grache::CLI.module_eval do
  desc 'Manage your pack'
  command :pack do |c|
    c.desc 'Build pack'
    c.command :build do |cmd|
      cmd.action do |global_options, options, _args|
        _opts = options.merge(global_options)
        Grache::Packer.new.pack
      end
    end

    c.desc 'Install pack'
    c.command :install do |cmd|
      cmd.action do |global_options, options, _args|
        _opts = options.merge(global_options)
        Grache::Packer.new.install
      end
    end

    c.desc 'Zip created pack'
    c.command :zip do |cmd|
      cmd.action do |global_options, options, _args|
        _opts = options.merge(global_options)
        Grache::Packer.new.zip
      end
    end
  end
end

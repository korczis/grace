# encoding: UTF-8

require 'pp'

require_relative '../shared'
require_relative '../../packer/packer'

Grache::CLI.module_eval do
  desc 'Pack gems'
  command :pack do |cmd|
    cmd.action do |global_options, options, _args|
      _opts = options.merge(global_options)
      Grache::Packer.new.pack
    end
  end
end

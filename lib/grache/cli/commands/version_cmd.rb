# encoding: UTF-8

require_relative '../shared'

Grache::CLI.module_eval do
  desc 'Show version'
  command :version do |cmd|
    cmd.action do
      puts Grache::VERSION
    end
  end
end

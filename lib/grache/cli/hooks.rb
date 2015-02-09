# encoding: UTF-8

require 'gli'
require 'pp'

Graces::CLI.module_eval do
  pre do |_global, _command, _options, _args|
    # Pre logic here
    # Return true to proceed; false to abort and not call the
    # chosen command
    # Use skips_pre before a command to skip this block
    # on that command only
    true
  end

  post do |_global, _command, _options, _args|
    # Post logic here
    # Use skips_post before a command to skip this
    # block on that command only
  end

  on_error do |_exception|
    # Error logic here
    # return false to skip default error handling
    # binding.pry
    # pp exception.backtrace
    # pp exception
    true
  end
end

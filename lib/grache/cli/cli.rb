# encoding: UTF-8

require 'gli'
require 'pp'

# Define Graces::CLI as GLI Wrapper
module Grache
  module CLI
    include GLI::App

    # Require shared part of GLI::App - flags, meta, etc
    require_relative 'shared.rb'

    # Require Hooks
    require_relative 'hooks.rb'

    GLI::App.commands_from(File.join(File.dirname(__FILE__), 'commands'))

    def self.main(args = ARGV)
      run(args)
    end
  end
end

Grache::CLI.main(ARGV) if __FILE__ == $PROGRAM_NAME

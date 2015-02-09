# encoding: UTF-8

require 'gli'

require_relative '../version'
# require_relative '../core/core'
# require_relative '../extensions/extensions'
# require_relative '../exceptions/exceptions'

include GLI::App

Grache::CLI.module_eval do
  program_desc 'Graces - Cache for ruby gems.'

  version Grache::VERSION
end

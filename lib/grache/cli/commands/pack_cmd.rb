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

    c.desc 'Deploy created pack'
    c.command :deploy do |cmd|
      cmd.desc 'AWS S3 Access Key Id'
      cmd.default_value nil
      cmd.flag 'access-key-id'

      cmd.desc 'AWS S3 Secret Access Key'
      cmd.default_value nil
      cmd.flag 'secret-access-key'

      cmd.action do |global_options, options, _args|
        opts = options.merge(global_options)

        access_key_id = opts['access-key-id']
        secret_access_key = opts['secret-access-key']

        Grache::Packer.new.deploy({access_key_id: access_key_id, secret_access_key: secret_access_key })
      end
    end

    c.desc 'Release pack - build, zip, deploy'
    c.command :release do |cmd|
      cmd.action do |global_options, options, _args|
        _opts = options.merge(global_options)

        ['pack build', 'pack zip', 'pack deploy'].each do |act|
          act_cmd = "#{$0} #{act}"
          system(act_cmd)
        end

        # Grache::Packer.new.install
      end
    end
  end
end

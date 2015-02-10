# encoding: utf-8

module Grache
  # Bundler related stuff
  module Bundler
    # See http://bundler.io/v1.3/man/bundle-install.1.html
    # TODO: Read this programmatically from bundler gem
    REMEMBERED_OPTIONS = [
      # Bundler will update the executables every subsequent call to bundle install.
      'binstubs',

      # At runtime, this remembered setting will also result in Bundler
      # raising an exception if the Gemfile.lock is out of date.
      'deployment',

      # Subsequent calls to bundle install will install gems to the directory originally passed to --path.
      # The Bundler runtime will look for gems in that location.
      # You can revert this option by running bundle install --system.
      'path',

      # As described above, Bundler will skip the gems specified by --without in subsequent calls to bundle install.
      # The Bundler runtime will also not try to make the gems in the skipped groups available.
      'without'
    ]

    class Bundler
    end
  end
end

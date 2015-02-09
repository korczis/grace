# encoding: utf-8

module Grache
  GIT_HASH = `git rev-parse HEAD`
  TIMESTAMP = Time.now.utc.strftime('%Y%m%d%H%M%S')
  # VERSION = "0.0.1-#{TIMESTAMP}-#{GIT_HASH}"
  VERSION = "0.0.1-#{GIT_HASH}"
end

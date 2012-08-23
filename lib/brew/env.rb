$:.unshift(File.expand_path("#{__FILE__}/../.."))

require 'brew/string+file'
require 'brew/homebrew'

require 'fileutils'
module Homebrew extend self
  include FileUtils
end

HOMEBREW_VERSION = "1.9" # constant because RUBY_VERSION

raise "Homebrew requires Ruby >= 1.8.6" if RUBY_VERSION < "1.8.6"


module Homebrew

  ArgumentError = Class.new(ArgumentError)

  extend self

  # These constants can be overridden be in brewrc, or via ENV, eg:
  #     Homebrew.CACHE = "/var/cache/brew"
  #     export HOMEBREW_CACHE="/var/cache/brew"
  # NOTE overriding PREFIX may be dumb, but whatever
  # TODO make the above promise true!
  PREFIX = __FILE__.dirname.parent.parent.cleanpath
  CACHE = "/Library/Caches/Homebrew"
  CELLAR = "#{PREFIX}/var/cellar"

  class Command
    # TODO resolve aliases if the formula_args function is called

    def initialize *args
      @args = args
    end

    def self.class_name cmd
      "Homebrew" + cmd.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }
    end

    def self.factory *args
      cmd = args.shift
      cmd = cmd[1..-1] if cmd.start_with? "--" # special cased
      path = "brew/cmd/brew-#{cmd}"
      require path
      class_name = class_name(cmd)
      Object.const_get(class_name).new(args)
    rescue ::ArgumentError => e
      raise Homebrew::ArgumentError.new(e)
    rescue LoadError => e
      raise "No such command: #{cmd}"
    end
  end

  module OS
    def self.check_sanity
      case RUBY_PLATFORM
      when /darwin/
        require 'brew/os/mac'
        Homebrew::OS::Mac.check_sanity
      end
    end
  end

end

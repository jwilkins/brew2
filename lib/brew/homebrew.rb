HOMEBREW_VERSION = "1.9" # constant because RUBY_VERSION

module Homebrew
  
  ArgumentError = Class.new(ArgumentError)
  
  extend self
  
  # The prefix where kegs are symlinked
  def prefix
    HOMEBREW_BREW_FILE.dirname.parent
  end

  def cache
    @cache ||= if ENV['HOMEBREW_CACHE']
      ENV['HOMEBREW_CACHE']
    else
      # we do this for historic reasons, however the cache *should* be the same
      # directory whichever user is used and whatever instance of brew is executed
      home_cache = "~/Library/Caches/Homebrew".expand_path
      if home_cache.directory? and home_cache.writable?
        home_cache
      else
        root_cache = "/Library/Caches/Homebrew"
        class << root_cache
          alias :oldmkpath :mkpath
          def mkpath
            unless exist?
              oldmkpath
              chmod 0777
            end
          end
        end
        root_cache
      end
    end
  end

  # The prefix where kegs are installed
  def cellar
    @cellar ||= begin
      postfix = "etc/brew/cellar"
      cellar = "#{prefix}/#{postfix}"
      if cellar.directory?
        cellar
      else
        "#{repo}/#{postfix}"
      end
    end
  end

  def active
    "#{Homebrew.prefix}/etc/brew/active"
  end

  class Command
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

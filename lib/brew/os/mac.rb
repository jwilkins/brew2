module Homebrew
  module OS
    module Mac extend self

      def check_sanity
        if version < 10.6
          raise <<-EOEX.undent
            Homebrew requires Snow Leopard or higher. For earlier support, see:
            http://github.com/sceaga/homebrew/tree/tiger
          EOEX
        end

        Dir.getwd rescue cd(prefix) # Reduces support burden
      end

      def full_version
        @full_version ||= `/usr/bin/sw_vers -productVersion`.chomp
      end

      def version
        @version ||= /(10\.\d+)(\.\d+)?/.match(full_version).captures.first.to_f
      end

      def cat
        case version
          when 10.8..10.9 then :mountain_lion
          when 10.7..10.8 then :lion
          when 10.6..10.7 then :snow_leopard
          when 10.5..10.6 then :leopard
        end
      end

    end
  end
end
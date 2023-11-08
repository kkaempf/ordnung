#
# cdrecord playlist
#
module Ordnung
  module Text
    class Pls < File
      def self.extensions
        ["pls"]
      end
      def self.properties
        nil
      end
    end
  end
end

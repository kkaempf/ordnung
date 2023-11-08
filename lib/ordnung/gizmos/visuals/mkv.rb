#
# Matroska data
#
module Ordnung
  module Visuals
    class Mkv < File
      def self.extensions
        ["mkv", "MKV"]
      end
      def self.properties
        nil
      end
    end
  end
end

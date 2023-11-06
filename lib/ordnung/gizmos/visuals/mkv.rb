#
# Matroska data
#
module Ordnung
  module Visuals
    class Mkv < File
      def self.extensions
        ["mkv", "MKV"]
      end
    end
  end
end

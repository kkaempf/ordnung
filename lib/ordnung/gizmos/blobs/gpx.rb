#
# GPS track
#
module Ordnung
  module Blobs
    class Gpx < File
      def self.extensions
        ["gpx"]
      end
      def self.properties
        nil
      end
    end
  end
end

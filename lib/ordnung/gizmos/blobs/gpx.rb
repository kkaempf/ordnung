#
# GPS track
#
module Ordnung
  module Blobs
    class Gpx < File
      def self.extensions
        ["gpx"]
      end
    end
  end
end

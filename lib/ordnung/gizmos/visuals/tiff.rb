#
# TIFF images
#
require 'exifr/tiff'

module Ordnung
  module Visuals
    class Tiff < File
      def self.extensions
        ["tiff", "TIFF"]
      end
      def initialize name, parent
        super name, parent
        exif = EXIFR::TIFF.new self.path
        if exif.exif?
          @width = exif.width
          @height = exif.height
          @date_time = exif.date_time
          if exif.gps
            @latitude = exif.gps.latitude
            @longitude = exif.gps.longitude
          end
        end
      end
      def to_s
        super + "\n\t#{@width}x#{@height} #{@date_time}"
      end
    end
  end
end

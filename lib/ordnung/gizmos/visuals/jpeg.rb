#
# JPEG pictures
#
require 'exifr/jpeg'

module Ordnung
  module Visuals
    class Jpeg < File
      def self.extensions
        ["jpg", "JPG", "jpeg", "JPEG"]
      end
      def initialize name, parent
        super name, parent
        exif = EXIFR::JPEG.new self.path
        @width = exif.width
        @height = exif.height
        @date_time = exif.date_time
        @latitude = exif.gps.latitude if exif.gps
        @longitude = exif.gps.longitude if exif.gps
      end
      def to_s
        super + "\n\t#{@width}x#{@height} #{@date_time} #{@latitude} #{@longitude}"
      end
    end
  end
end

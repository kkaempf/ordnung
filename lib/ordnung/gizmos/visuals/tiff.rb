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
      def self.properties
        nil
      end
      def initialize name, parent
        super name, parent
        tiff = EXIFR::TIFF.new self.path
        @width = tiff.width
        @height = tiff.height
        @date_time = tiff.date_time
      end
      def to_s
        super + "\n\t#{@width}x#{@height} #{@date_time}"
      end
    end
  end
end

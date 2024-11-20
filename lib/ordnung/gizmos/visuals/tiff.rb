require 'exifr/tiff'

module Ordnung
  # namespace for anything visual (pictures, videos, ...)
  module Visuals
    #
    # TIFF images
    #
    class Tiff < File
      # extensions associated with +tiff+ pictures
      def self.extensions
        ["tiff", "TIFF"]
      end
      # properties of +tiff+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
      #
      # New TIFF file
      #
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

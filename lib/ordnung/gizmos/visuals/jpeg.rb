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
      #
      # Database type mapping
      #
      def self.properties
        {
          '@width':     { type: 'integer' },
          '@height':    { type: 'integer' },
          '@exif_date': { type: 'date' },
          '@latitude':  { type: 'keyword' },
          '@longitude': { type: 'keyword' }
        }
      end
      #
      # New JPEG file
      #
      def initialize name, parent_id
        super name, parent_id
        case name
        when String, Pathname
          Gizmo.log.info "Jpeg.new #{name.inspect}, #{parent_id}"
          exif = EXIFR::JPEG.new self.path
          @width = exif.width
          @height = exif.height
          @date_time = exif.date_time
          @latitude = exif.gps.latitude if exif.gps
          @longitude = exif.gps.longitude if exif.gps
        when Hash
          @width = name['@width']
          @height = name['@height']
          @date_time = name['@exif_date']
          @latitude = name['@latitude']
          @longitude = name['@longitude']
        end
      end
      def to_s
        super + "\n\t#{@width}x#{@height} #{@date_time} #{@latitude} #{@longitude}"
      end
    end
  end
end

require 'gif-info'

module Ordnung
  # namespace for anything visual (pictures, videos, ...)
  module Visuals
    #
    # GIF pictures
    #
    class Gif < File
      # extensions associated with +gif+ picture files
      def self.extensions
        ["gif", "GIF"]
      end
      #
      # properties of +gif+ files (beyond what +File+ already provides)
      #
      def self.properties
        {
          'width':     { type: 'integer' },
          'height':    { type: 'integer' },
        }
      end
      #
      # New GIF file
      #
      def initialize props, parent_id=nil, pathname=nil
        super
        case props
        when String, Pathname
          Gizmo.log.info "Gif.new #{name.inspect}, #{parent_id}"
          info = ::GifInfo.analyze_file pathname
          @properties[:width] = info.width
          @properties[:height] = info.height
          upsert
        end
      end
      def to_s
        super + "\n\t#{width}x#{height}"
      end
    end
  end
end

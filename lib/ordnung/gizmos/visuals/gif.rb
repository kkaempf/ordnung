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
      def initialize name, parent_id
        super name, parent_id
        case name
        when String, Pathname
          Gizmo.log.info "Gif.new #{name.inspect}, #{parent_id}"
          info = ::GifInfo.new self.path
          @width = info.width
          @height = info.height
        when Hash
          @width = name['width']
          @height = name['height']
        end
      end
      def to_s
        super + "\n\t#{@width}x#{@height}"
      end
    end
  end
end

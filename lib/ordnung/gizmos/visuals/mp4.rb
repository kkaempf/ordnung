module Ordnung
  # namespace for anything visual (pictures, videos, ...)
  module Visuals
    #
    # MPEG4 video files
    #
    class Mp4 < File
      # extensions associated with +mpeg4+ video files
      def self.extensions
        ["mp4"]
      end
      # properties of +mpeg4+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

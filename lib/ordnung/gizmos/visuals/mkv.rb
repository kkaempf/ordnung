module Ordnung
  # namespace for anything visual (pictures, videos, ...)
  module Visuals
    #
    # Matroska data
    #
    class Mkv < File
      # extensions associated with +matroska+ video files
      def self.extensions
        ["mkv", "MKV"]
      end
      # properties of +matroska+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

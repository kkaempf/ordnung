module Ordnung
  # namespace for anything visual (pictures, videos, ...)
  module Visuals
    #
    # Avi video file
    #
    class Avi < File
      # extensions associated with +avi+ video files
      def self.extensions
        ["avi"]
      end
      # properties of +avi+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

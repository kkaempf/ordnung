module Ordnung
  # namespace for anything visual (pictures, videos, ...)
  module Visuals
    #
    # Mov video files
    #
    class Mov < File
      # extensions associated with +mov+ video files
      def self.extensions
        ["mov", "MOV"]
      end
      # properties of +mov+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

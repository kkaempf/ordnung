module Ordnung
  # namespace for anything visual (pictures, videos, ...)
  module Visuals
    #
    # ISO Media, Apple QuickTime movie, Apple QuickTime (.MOV/QT)
    #
    class M4v < File
      # extensions associated with +quicktime+ files
      def self.extensions
        ["m4v"]
      end
      # properties of +quicktime+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

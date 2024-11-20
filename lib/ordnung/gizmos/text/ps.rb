module Ordnung
  # namespace for text files
  module Text
    #
    # PostScript
    #
    class Ps < File
      # list of extensions associated with +postscript+ files
      def self.extensions
        ["ps", "PS"]
      end
      # properties of +postscript+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

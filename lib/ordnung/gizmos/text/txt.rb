module Ordnung
  # namespace for text files
  module Text
    #
    # simple text file
    #
    class Txt < File
      # list of extensions associated with +text+ files
      def self.extensions
        ["txt", "TXT"]
      end
      # properties of +txt+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

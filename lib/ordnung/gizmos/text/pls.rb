module Ordnung
  # namespace for text files
  module Text
    #
    # cdrecord playlist
    #
    class Pls < File
      # list of extensions associated with +pls+ files
      def self.extensions
        ["pls"]
      end
      # properties of +pls+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

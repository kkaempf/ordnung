module Ordnung
  # namespace for text files
  module Text
    #
    # XML
    #
    class Xml < File
      # list of extensions associated with +xml+ files
      def self.extensions
        ["xml", "XML"]
      end
      # properties of +xml+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

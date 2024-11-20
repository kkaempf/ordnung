module Ordnung
  # namespace for text files
  module Text
    #
    # PDF file
    #
    class Pdf < File
      # list of extensions associated with +pdf+ files
      def self.extensions
        ["pdf", "PDF"]
      end
      # properties of +pdf+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

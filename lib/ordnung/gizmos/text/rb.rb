module Ordnung
  # namespace for text files
  module Text
    #
    # Ruby
    #
    class Rb < File
      # list of extensions associated with +Ruby+ files
      def self.extensions
        ["rb"]
      end
      # properties of +Ruby+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

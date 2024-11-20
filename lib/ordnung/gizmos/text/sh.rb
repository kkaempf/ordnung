module Ordnung
  # namespace for text files
  module Text
    #
    # Shell script
    #
    class Sh < File
      # list of extensions associated with +shell+ script
      def self.extensions
        ["sh"]
      end
      # properties of +shell+ scripts (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

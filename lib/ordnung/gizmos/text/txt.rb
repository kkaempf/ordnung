module Ordnung
  module Text
    class Txt < File
      def self.extensions
        ["txt", "TXT"]
      end
      def self.properties
        nil
      end
    end
  end
end

module Ordnung
  module Text
    class Pdf < File
      def self.extensions
        ["pdf", "PDF"]
      end
      def self.properties
        nil
      end
    end
  end
end

module Ordnung
  module Text
    class Pdf < File
      def self.extensions
        ["pdf", "PDF"]
      end
    end
  end
end

module Ordnung
  module Text
    class Txt < File
      def self.extensions
        ["txt", "TXT"]
      end
    end
  end
end

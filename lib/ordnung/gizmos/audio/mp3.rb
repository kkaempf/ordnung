module Ordnung
  module Audio
    class Mp3 < File
      def self.extensions
        ["mp3"]
      end
      def self.properties
        nil
      end
    end
  end
end

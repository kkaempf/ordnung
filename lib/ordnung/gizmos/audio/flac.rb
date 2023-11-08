module Ordnung
  module Audio
    class Flac < File
      def self.extensions
        ["flac"]
      end
      def self.properties
        nil
      end
    end
  end
end

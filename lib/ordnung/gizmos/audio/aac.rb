module Ordnung
  module Audio
    class Aac < File
      def self.extensions
        ["aac"]
      end
      def self.properties
        nil
      end
    end
  end
end

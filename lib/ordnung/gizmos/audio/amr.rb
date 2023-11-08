module Ordnung
  module Audio
    class Amr < File
      def self.extensions
        ["amr"]
      end
      def self.properties
        nil
      end
    end
  end
end

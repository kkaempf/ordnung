module Ordnung
  module Visuals
    class Png < File
      def self.extensions
        ["png", "PNG"]
      end
      def self.properties
        nil
      end
    end
  end
end

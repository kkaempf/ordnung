module Ordnung
  module Containers
    class Zip < File
      def self.extensions
        ["zip", "ZIP"]
      end
      def self.properties
        nil
      end
      def initialize name, parent=nil
        super name, parent
      end
    end
  end
end

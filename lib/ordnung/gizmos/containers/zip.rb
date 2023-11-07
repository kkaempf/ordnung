module Ordnung
  module Containers
    class Zip < File
      def self.extensions
        ["zip", "ZIP"]
      end
      def initialize name, parent=nil
        super name, parent
      end
    end
  end
end

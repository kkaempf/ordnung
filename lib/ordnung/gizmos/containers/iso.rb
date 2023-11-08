#
# CD or DVD images
#
module Ordnung
  module Containers
    class Iso < File
      def self.extensions
        ["iso", "ISO"]
      end
      def self.properties
        nil
      end
    end
  end
end

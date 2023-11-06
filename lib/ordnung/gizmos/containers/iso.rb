#
# CD or DVD images
#
module Ordnung
  module Containers
    class Iso < File
      def self.extensions
        ["iso", "ISO"]
      end
    end
  end
end

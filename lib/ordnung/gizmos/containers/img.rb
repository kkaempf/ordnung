#
# disk images
#
module Ordnung
  module Containers
    class Img < File
      def self.extensions
        ["img", "IMG"]
      end
      def self.properties
        nil
      end
    end
  end
end

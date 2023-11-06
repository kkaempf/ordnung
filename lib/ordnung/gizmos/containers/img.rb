#
# disk images
#
module Ordnung
  module Containers
    class Img < File
      def self.extensions
        ["img", "IMG"]
      end
    end
  end
end

#
# disk images
#
module Ordnung
  # namespace for containers
  module Containers
    # disk images
    class Img < Container
      # extensions associated with +image+ files
      def self.extensions
        ["img", "IMG"]
      end
      # properties of +image+ files (beyond what +Container+ already provides)
      def self.properties
        nil
      end
    end
  end
end

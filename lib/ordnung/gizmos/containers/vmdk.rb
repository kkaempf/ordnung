module Ordnung
  # namespace for containers
  module Containers
    # VMware image files
    class Vmdk < Container
      # extensions associated with +vmdk+ files
      def self.extensions
        ["vmdk"]
      end
      # properties of +vmdk+ files (beyond what +Container+ already provides)
      def self.properties
        nil
      end
    end
  end
end

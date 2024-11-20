module Ordnung
  # namespace for containers
  module Containers
    # ZIP archives
    class Zip < Container
      # extensions associated with +vmdk+ files
      def self.extensions
        ["zip", "ZIP"]
      end
      # properties of +zip+ files (beyond what +Container+ already provides)
      def self.properties
        nil
      end
    end
  end
end

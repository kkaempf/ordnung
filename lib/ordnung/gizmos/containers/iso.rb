module Ordnung
  # namespace for containers
  module Containers
    #
    # CD or DVD images
    #
    class Iso < Container
      # extensions associated with +iso+ files
      def self.extensions
        ["iso", "ISO"]
      end
      # properties of +iso+ files (beyond what +Container+ already provides)
      def self.properties
        nil
      end
    end
  end
end

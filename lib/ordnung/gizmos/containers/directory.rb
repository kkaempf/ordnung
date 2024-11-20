module Ordnung
  # namespace for containers
  module Containers
    #
    # file system directory
    #
    class Directory < Container
      #
      # extensions associated with +directory+ files
      #
      def self.extensions
        ["DIR", "dir"]
      end
      #
      # properties of +directory+ files (beyond what +Container+ already provides)
      #
      def self.properties
        nil
      end
      #
      # create new directory instance
      #
      def initialize name, parent
        super name, parent
        @hash = nil
      end
    end
  end
end

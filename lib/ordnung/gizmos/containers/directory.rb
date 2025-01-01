module Ordnung
  # namespace for containers
  module Containers
    #
    # file system directory
    #
    class Directory < Container
      def log
        ::Ordnung.logger
      end
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
    end
  end
end

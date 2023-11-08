module Ordnung
  module Containers
    class Tar < File
      def self.extensions
        ["tar", "TAR", "tar.gz", "tar.bz"]
      end
      def self.properties
        nil
      end
      def initialize path
        super path
      end
    end
  end
end

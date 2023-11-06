module Ordnung
  module Containers
    class Tar < File
      def self.extensions
        ["tar", "TAR", "tar.gz", "tar.bz"]
      end
      def initialize path
        super path
      end
    end
  end
end

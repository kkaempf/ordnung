module Ordnung
  # namespace for containers
  module Containers
    # tar files
    class Tar < Container
      # extensions associated with +tar+ files
      def self.extensions
        ["tar", "TAR", "tar.gz", "tar.bz"]
      end
      # properties of +tar+ files (beyond what +Container+ already provides)
      def self.properties
        nil
      end
    end
  end
end

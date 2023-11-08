#
# 7z archive
#
module Ordnung
  module Containers
    class Sevenz < File
      def self.extensions
        ["7z"]
      end
      def self.properties
        nil
      end
    end
  end
end

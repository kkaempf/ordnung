#
# 7z archive
#
module Ordnung
  module Containers
    class Sevenz < File
      def self.extensions
        ["7z"]
      end
    end
  end
end

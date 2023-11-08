#
# Open Streetmap File
#
module Ordnung
  module Blobs
    class Obf < File
      def self.extensions
        ["obf"]
      end
      def self.properties
        nil
      end
    end
  end
end

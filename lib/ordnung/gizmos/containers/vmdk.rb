module Ordnung
  module Containers
    class Vmdk < File
      def self.extensions
        ["vmdk"]
      end
      def self.properties
        nil
      end
    end
  end
end

module Ordnung
  module Containers
    class Vmdk < File
      def self.extensions
        ["vmdk"]
      end
    end
  end
end

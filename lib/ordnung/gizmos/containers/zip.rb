module Ordnung
  module Containers
    class Zip < File
      def self.extensions
        ["zip", "ZIP"]
      end
      def initialize path
        super path
      end
    end
  end
end

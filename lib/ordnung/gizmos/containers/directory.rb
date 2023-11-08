module Ordnung
  module Containers
    class Directory < Container
      def self.extensions
        ["DIR", "dir"]
      end
      def self.properties
        nil
      end
      def initialize name, parent
        super name, parent
        @hash = nil
      end
    end
  end
end

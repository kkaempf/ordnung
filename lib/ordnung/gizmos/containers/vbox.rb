module Ordnung
  module Containers
    class Vbox < File
      def self.extensions
        ["vbox", "vbox-prev"]
      end
      def self.properties
        nil
      end
    end
  end
end

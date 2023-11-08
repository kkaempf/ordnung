#
# XML
#
module Ordnung
  module Text
    class Xml < File
      def self.extensions
        ["xml", "XML"]
      end
      def self.properties
        nil
      end
    end
  end
end

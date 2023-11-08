#
# PostScript
#
module Ordnung
  module Text
    class Ps < File
      def self.extensions
        ["ps", "PS"]
      end
      def self.properties
        nil
      end
    end
  end
end

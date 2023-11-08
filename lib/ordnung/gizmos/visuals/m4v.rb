#
# ISO Media, Apple QuickTime movie, Apple QuickTime (.MOV/QT)
#
module Ordnung
  module Visuals
    class M4v < File
      def self.extensions
        ["m4v"]
      end
      def self.properties
        nil
      end
    end
  end
end

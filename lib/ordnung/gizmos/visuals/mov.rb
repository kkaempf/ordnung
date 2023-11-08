#
# ISO Media, Apple QuickTime movie, Apple QuickTime (.MOV/QT)
#
module Ordnung
  module Visuals
    class Mov < File
      def self.extensions
        ["mov", "MOV"]
      end
      def self.properties
        nil
      end
    end
  end
end

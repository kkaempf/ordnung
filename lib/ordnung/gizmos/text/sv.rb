#
# FPGA sv
#
module Ordnung
  module Text
    class Sv < File
      def self.extensions
        ["sv"]
      end
      def self.properties
        nil
      end
    end
  end
end

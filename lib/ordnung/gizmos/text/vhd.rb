#
# FPGA vhd
#
module Ordnung
  module Text
    class Vhd < File
      def self.extensions
        ["vhd"]
      end
      def self.properties
        nil
      end
    end
  end
end

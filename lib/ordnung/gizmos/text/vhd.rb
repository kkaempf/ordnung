#
# FPGA vhd
#
module Ordnung
  module Text
    class Vhd < File
      def self.extensions
        ["vhd"]
      end
    end
  end
end

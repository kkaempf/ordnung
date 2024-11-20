module Ordnung
  # namespace for text files
  module Text
    #
    # FPGA vhd
    #
    class Vhd < File
      # list of extensions associated with +vhd+ files
      def self.extensions
        ["vhd"]
      end
      # properties of +vhd+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

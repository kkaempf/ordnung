module Ordnung
  # namespace for text files
  module Text
    #
    # FPGA sv
    #
    class Sv < File
      # list of extensions associated with +sv+ files
      def self.extensions
        ["sv"]
      end
      # properties of +sv+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

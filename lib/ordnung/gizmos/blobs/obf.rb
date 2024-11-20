module Ordnung
  # container namespace for Blob
  module Blobs
    #
    # Open Streetmap File
    #
    class Obf < File
      # extensions associated with +obf+ files
      def self.extensions
        ["obf"]
      end
      # properties of +obf+ file (beyond what +Blob+ already provides)
      def self.properties
        nil
      end
    end
  end
end

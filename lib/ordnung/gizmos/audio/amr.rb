module Ordnung
  # namespace for Audio files
  module Audio
    # Audio file in +amr+ encoding
    class Amr < File
      # @returns extensions associated with amr files
      def self.extensions
        ["amr"]
      end
      # properties of amr (beyond what +File+ provides)
      def self.properties
        nil
      end
    end
  end
end

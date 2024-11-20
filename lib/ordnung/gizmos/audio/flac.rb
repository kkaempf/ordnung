module Ordnung
  # namespace for Audio files
  module Audio
    # Audio file in +flac+ encoding
    class Flac < File
      # @returns extensions associated with flac files
      def self.extensions
        ["flac"]
      end
      # properties of flac (beyond what +File+ provides)
      def self.properties
        nil
      end
    end
  end
end

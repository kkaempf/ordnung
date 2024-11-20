module Ordnung
  # namespace for Audio files
  module Audio
    # Audio file in +mp3+ encoding
    class Mp3 < File
      # @returns extensions associated with mp3 files
      def self.extensions
        ["mp3"]
      end
      # properties of mp3 (beyond what +File+ provides)
      def self.properties
        nil
      end
    end
  end
end

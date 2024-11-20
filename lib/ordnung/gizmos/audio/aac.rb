module Ordnung
  # namespace for Audio files
  module Audio
    # Audio file in +aac+ encoding
    class Aac < File
      # @returns extensions associated with aac files
      def self.extensions
        ["aac"]
      end
      # properties of aac (beyond what +File+ provides)
      def self.properties
        nil
      end
    end
  end
end

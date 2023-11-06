module Ordnung
  module Audio
    class Flac < File
      def self.extensions
        ["flac"]
      end
    end
  end
end

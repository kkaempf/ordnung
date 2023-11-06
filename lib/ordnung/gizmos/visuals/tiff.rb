module Ordnung
  module Visuals
    class Tiff < File
      def self.extensions
        ["tiff", "TIFF"]
      end
    end
  end
end

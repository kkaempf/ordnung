module Ordnung
  # namespace for anything visual (pictures, videos, ...)
  module Visuals
    #
    # PNG pictures
    #
    class Png < File
      # extensions associated with +png+ pictures
      def self.extensions
        ["png", "PNG"]
      end
      # properties of +png+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

module Ordnung
  module Visuals
    class Jpeg < File
      def self.extensions
        ["jpg", "JPG", "jpeg", "JPEG"]
      end
    end
  end
end

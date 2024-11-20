module Ordnung
  # container namespace for Blob
  module Blobs
    #
    # GPS track
    #
    class Gpx < Blob
      # extensions associated with +gpx+ files
      def self.extensions
        ["gpx"]
      end
      # properties of +gpx+ file (beyond what +Blob+ already provides)
      def self.properties
        nil
      end
    end
  end
end

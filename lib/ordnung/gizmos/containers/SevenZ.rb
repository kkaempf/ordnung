module Ordnung
  module Containers
    #
    # 7z archive
    #
    class Sevenz < Container
      # extensions associated with +7z+ files
      def self.extensions
        ["7z"]
      end
      # properties of +7z+ files (beyond what +Container+ already provides)
      def self.properties
        nil
      end
    end
  end
end

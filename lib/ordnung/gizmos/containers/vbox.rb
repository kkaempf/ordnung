module Ordnung
  # namespace for containers
  module Containers
    # VirtualBox image files
    class Vbox < Container
      # extensions associated with +vbox+ files
      def self.extensions
        ["vbox", "vbox-prev"]
      end
      # properties of +vbox+ files (beyond what +Container+ already provides)
      def self.properties
        nil
      end
    end
  end
end

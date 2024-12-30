module Ordnung
  # namespace for containers
  module Containers
    #
    # file system directory
    #
    class Directory < Container
      def log
        ::Ordnung.logger
      end
      #
      # extensions associated with +directory+ files
      #
      def self.extensions
        ["DIR", "dir"]
      end
      #
      # properties of +directory+ files (beyond what +Container+ already provides)
      #
      def self.properties
        nil
      end
      #
      # create new directory instance
      #
      def initialize name, parent_id, pathname=nil
        log.info "#{self.class.inspect}.new #{name.inspect}, #{parent_id.inspect}, #{pathname.inspect}"
        super name, parent_id, pathname || name
        @hash = nil
      end
    end
  end
end

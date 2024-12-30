require_relative 'file'

module Ordnung
  #
  # A +Container+ doesn't provide any actual content
  # but provides a collection of Files
  #
  # Used to represent directories and archives (tar, zip, ...)
  #
  class Container < ::Ordnung::File
    def log
      ::Ordnung.logger
    end
    #
    # is not associated with any extensions
    # @return nil
    #
    def self.extensions
      nil # abstract
    end
    #
    # doesn't have any properties
    # @return nil
    #
    def self.properties
      nil
    end
    #
    # return new instance of +Container+
    #
    def initialize name, parent_id, pathname
      log.info "Ordnung::Container.new #{name.inspect}, #{parent_id.inspect}, #{pathname.inspect}"
      super name, parent_id, pathname
    end
    #
    # iterate over each gizmo in Container
    # @return Iterator
    #
    def each_gizmo
    end
  end
end

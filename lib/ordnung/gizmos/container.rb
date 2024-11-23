module Ordnung
  #
  # A +Container+ doesn't provide any actual content
  # but provides a collection of Files
  #
  # Used to represent directories and archives (tar, zip, ...)
  #
  class Container < File
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
    def initialize path, parent
      super path, parent
    end
    #
    # iterate over each gizmo in Container
    # @return Iterator
    #
    def each_gizmo
    end
  end
end

module Ordnung
  class Container < File
    def self.extensions
      nil # abstract
    end
    def self.properties
      nil
    end
    def initialize path
      super path
    end
    #
    # iterate over each gizmo in Container
    # @return Iterator
    def each_gizmo
    end
  end
end

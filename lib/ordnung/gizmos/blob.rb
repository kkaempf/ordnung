module Ordnung
  class Blob < File
    def self.extensions
      nil # abstract
    end
    def self.properties
      nil
    end
    def initialize name, parent_id
      super name, parent_id
#      Gizmo.log.info "Blob.new(#{path.inspect}, #{parent_id.inspect})"
    end
  end
end

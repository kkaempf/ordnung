module Ordnung
  class Blob < File
    def self.extensions
      nil # abstract
    end
    def self.properties
      nil
    end
    def initialize path, parent_id
#      Gizmo.log.info "Blob.new(#{path.inspect}, #{parent_id.inspect})"
      super path, parent_id
    end
  end
end

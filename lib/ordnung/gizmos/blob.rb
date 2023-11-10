module Ordnung
  class Blob < File
    def self.extensions
      nil # abstract
    end
    def self.properties
      nil
    end
    def initialize name, parent_id
      super
      Gizmo.log.info "Blob.new(#{name.inspect}, #{parent_id.inspect})"
    end
  end
end

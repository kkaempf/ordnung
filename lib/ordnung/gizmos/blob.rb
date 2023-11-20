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
#      Gizmo.log.info "Blob.#{__callee__}(#{name.class}:#{name}, #{parent_id.inspect})"
    end
    def == blob
      super && self.class == blob.class
    end
  end
end

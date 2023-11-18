module Ordnung
  class Blob < File
    def self.extensions
      nil # abstract
    end
    def self.properties
      nil
    end
    def initialize name, parent_id
#      Gizmo.log.info "#{__callee__}: Blob.new(#{name.inspect}, #{parent_id.inspect})"
      super
    end
  end
end

module Ordnung
  #
  # Representing a binary large object
  # just a stream of bytes without associated type
  #
  # Acts as an abstract base class for the actual file types
  #
  class Blob < File
    #
    # @return list of extensions associated to this type
    #
    def self.extensions
      nil # abstract
    end
    #
    # properties of file
    #
    def self.properties
      nil
    end
    #
    # Create +Blob* instance
    #
    def initialize name, parent_id
      super name, parent_id
#      Gizmo.log.info "Blob.#{__callee__}(#{name.class}:#{name}, #{parent_id.inspect})"
    end
    #
    # check for equality
    #
    def == blob
      super(blob) && (self.class == blob.class)
    end
  end
end

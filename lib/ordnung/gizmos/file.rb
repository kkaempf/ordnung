module Ordnung
  class File < Gizmo
    attr_reader :date, :size, :hash
    def self.extensions
      nil # abstract
    end
    def initialize path, parent=nil
      super name, parent
    end
  end
end

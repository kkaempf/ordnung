module Ordnung
  class Blob < File
    def self.extensions
      nil # abstract
    end
    def initialize path, parent
      super path, parent
    end
  end
end

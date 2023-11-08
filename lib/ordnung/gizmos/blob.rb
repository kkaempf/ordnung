module Ordnung
  class Blob < File
    def self.extensions
      nil # abstract
    end
    def self.properties
      nil
    end
    def initialize path, parent
      super path, parent
    end
  end
end

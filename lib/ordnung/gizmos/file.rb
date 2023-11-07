module Ordnung
  class File < Gizmo
    attr_reader :date, :size, :hash
    def self.extensions
      nil # abstract
    end
    def initialize name, parent=nil
      super name, parent
      path = self.path
      @hash = `sha256sum -b #{path}`.split(' ')[0]
      @size = ::File.size(path)
      @time = ::File.mtime(path)
    end
    def to_s
      "#{self.path} #{@size} #{@time} #{@hash}"
    end
  end
end

module Ordnung
  class File < Gizmo
    def self.extensions
      nil # abstract
    end
    #
    # Database type mapping
    #
    def self.properties
      {
      	hash: { type: 'keyword' },
        size: { type: 'integer' },
        time: { type: 'date' }
      }
    end
    #
    #
    #
    def initialize name, parent_id=nil
      super
      Gizmo.log.info "File.new(#{name})"
      case name
      when String, Pathname
        path = self.path
        @hash = `sha256sum -b #{path}`.split(' ')[0]
        @size = ::File.size(path)
        @time = ::File.mtime(path)
      when Hash
        @hash = name['hash']
        @size = name['size']
        @time = name['time']
      end
    end
    def == file
      super file &&
        @hash==file.hash &&
        @size == file.size &&
        @time == file.time
    end
    def to_s
      "#{self.path} #{@size} #{@time} #{@hash}"
    end
  end
end

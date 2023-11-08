module Ordnung
  class File < Gizmo
    attr_reader :date, :size, :hash
    def self.extensions
      nil # abstract
    end
    #
    # Database type mapping
    #
    def self.mapping
      { properties: {
          hash: { type: 'keyword' },
          size: { type: 'integer' },
          time: { type: 'date' }
        }
      }
    end
    #
    #
    #
    def initialize name, parent=nil
      super name, parent
      case name
      when String
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
    def to_s
      "#{self.path} #{@size} #{@time} #{@hash}"
    end
  end
end

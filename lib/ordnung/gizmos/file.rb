module Ordnung
  #
  # File represents an actual file on disk, which has
  # * actual content (represented as checksum hash)
  # * a size (can be 0)
  # * a timestamp (coming from the on-disk filesystem)
  #
  # File is an abstract concept, actual uses should be derived from File
  #
  class File < Gizmo
    #
    # no associated extensions
    # @return nil
    #
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
        time: { type: 'date', format: 'yyyy-MM-dd HH:mm:ss Z' } # 2023-11-08 16:03:40 +0100
      }
    end
    #
    # +hash+ : checksum of File
    # +size+ : number of bytes
    # +time+ : timestamp from filesystem
    #
    attr_reader :hash, :size, :time
    #
    # create instance of File
    #
    def initialize name, parent_id=nil
      super
#      Gizmo.log.info "File.new(#{name.class}:#{name})"
      case name
      when String, Pathname
        path = self.path
        @hash = `sha256sum -b #{path}`.split(' ')[0]
        @size = ::File.size(path)
        @time = ::File.mtime(path).floor
      when Hash
        @hash = name['@hash']
        @size = name['@size']
        @time = Time.new(name['@time'])
      end
    end
    #
    # check for equality
    #
    def == file
      super && file.class == self.class &&
        @hash == file.hash &&
        @size == file.size &&
        @time == file.time
    end
    #
    # string representation for debugging/logging purposes
    #
    def to_s
      "#{self.path} #{@size} #{@time} #{@hash}"
    end
  end
end

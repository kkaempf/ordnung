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
    # fixme
    #
    def self.init
      @@index = 'ordnung-files'
      Ordnung::Db.create_index @@index
    end
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
    def initialize pathname, parent_id=nil
      super
      Gizmo.log.info "File.new(#{pathname.class}:#{name})"
      case pathname
      when String, Pathname
        @hash = `sha256sum -b #{pathname}`.split(' ')[0]
        @size = ::File.size(pathname)
        @time = ::File.mtime(pathname).floor
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
    #
    # iterate over each file
    # @return Iterator
    #
    def each
    end
    #
    # iterate over each assigned tag
    # @return Iterator
    #
    def each_tag
    end
    #
    # File#has? tag
    # @return Boolean
    #
    def has? tag
      tag.to? @id
    end
    #
    # File#tag! tag
    # add tag to file
    #
    def tag tg
      tg.tag @id
    end
    #
    # File#untag! tag
    # remove tag from file
    #
    def untag tag
      tag.untag @id
    end
  end
end

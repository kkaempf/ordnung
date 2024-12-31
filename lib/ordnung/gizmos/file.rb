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
      @@properties = self.properties.merge!(self.superclass.properties)
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
        time: { type: 'date', doc_value: true }
      }
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    public
    def log
      ::Ordnung.logger
    end
    #
    #
    #
    def upsert hash={}
      super hash.merge!({ hash: @hash, size: @size, time: @time })
    end
    #
    # +hash+ : checksum of File
    # +size+ : number of bytes
    # +time+ : timestamp from filesystem
    #
    attr_reader :hash, :size, :time, :properties
    #
    # create instance of File or Directory
    #
    # Since Ordnung:File is a parent class of Ordnung::Container::Directory,
    # this initialization routine is called for plain files and directories.
    #
    def initialize name, parent_id, pathname=nil
      log.info "Ordnung::File.new #{name.inspect}, #{parent_id.inspect}, #{pathname.inspect}"
      super name, parent_id
      case name
      when Pathname, String
        raise "No pathname" if pathname.nil?
        @hash = if pathname.directory?
                  nil
                else
                  `sha256sum -b #{pathname}`.split(' ')[0]
                end
        @size = ::File.size(pathname)
        @time = ::File.mtime(pathname).to_i
      when Hash
        @hash = name['hash']
        @size = name['size']
        @time = name['time']
      else
        raise "Ordnung::Fleet.new #{name.class} unhandled"
      end
    end
    #
    # check for equality
    #
    def == other
      other &&
        self.class == other.class &&
        super &&
        @hash == other.hash &&
        @size == other.size &&
        @time == other.time
    end
    #
    # string representation for debugging/logging purposes
    #
    def to_s
      "#{self.path} #{@size} #{@time} #{@hash}"
    end
  end
end

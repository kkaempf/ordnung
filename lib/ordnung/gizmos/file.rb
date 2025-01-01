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
        time: { type: 'date', doc_value: true }
      }
    end
    #
    # iterator
    #
    def self.each options={}, &block
      log.info "File.each #{block_given?}"
      @@db.each @@index, options, &block
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    public
    def log
      ::Ordnung.logger
    end
    #
    # create instance of File or Directory
    #
    # Since Ordnung:File is a parent class of Ordnung::Container::Directory,
    # this initialization routine is called for plain files and directories.
    #
    def initialize name, parent_id=nil, pathname=nil
      log.info "Ordnung::File.new #{name.inspect}, #{parent_id.inspect}, #{pathname.inspect}"
      super name, parent_id
      case name
      when Pathname, String
        raise "No pathname" if pathname.nil?
        @properties['hash'] = if pathname.directory?
                               nil
                             else
                               `sha256sum -b #{pathname}`.split(' ')[0]
                             end
        @properties['size'] = ::File.size(pathname)
        @properties['time'] = ::File.mtime(pathname).to_i
      when Hash
        @properties = name
      else
        raise "Ordnung::File.new #{name.class} unhandled"
      end
    end
  end
end

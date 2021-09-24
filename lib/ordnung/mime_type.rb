#
# MimeType
#
# representing mimetypes (type identifier and extensions)
#
# Implementation notes
#  mimetype can't be used as _key since it contains '/' :-/
#

module Ordnung
  class MimeType
    def self.server
      @@database.server
    end
    def self.database
      @@database
    end
    def self.database= database
      @@database = database
    end
    def self.setup
      @@collection = if database.collection_exists?(name: "MimeTypes")
                       database.get_collection(name: "MimeTypes")
                     else
                       database.create_collection(name: "MimeTypes")
                     end
    end
    def self.cleanup
      @@database.delete_collection(name: "MimeTypes") rescue nil
    end
    #
    # class level
    #
    private
    # read mime.type file, find extension match
    # @return [ mime_type, extensions... ]
    def self._find_matching_mimetype ext
      path = ::File.join(TOPLEVEL, "config", "mime.types")            # assume file in config/
      unless ::File.readable? path
        Logger.error "Can't read mime type file #{path}: #{e}"
        return nil
      end
      ::File.open(path) do |f|
        f.each do |l|
          case l
          when/^\#/  # comment
            next
          when /^([^\s]+)\s+([^\n]+)\n$/
            m_type = $1  # mime type
            m_extensions = $2.split(' ')
            if m_extensions.include? ext
              return [ m_type ] + m_extensions
            end
          else
            raise "Unrecognizable entry in #{path}: #{l.inspect}"
          end
        end
      end
      nil # no match found in mime.types
    end
    public
    #
    # match filename to MimeType
    # @param filename
    # @returns MimeType
    def self.match filename
      *names, ext = filename.split '.'
      mimetype = nil
      unless names.empty? # have extension
        mimetype, *extensions = MimeType._find_matching_mimetype(ext)
      end
      unless mimetype.nil? # matching extension found
#        Logger.info "#{filename} is a #{mimetype}:#{extensions.inspect}"
        return MimeType.create(mimetype, extensions)
      end
      # last resort: binary blob
#      Logger.info("#{filename} is a BLOB")
      return MimeType.create("application/octet-stream", [])
    end

    #
    # Collection I/O
    #

    #
    # create new MimeType
    # @returns MimeType
    #
    def self.create(mimetype, extensions)
#      Logger.info "MimeType.create #{mimetype.inspect},#{extensions.inspect}"
      m = self.get(mimetype)
      return m if m
      extensions = nil if extensions.empty?
      MimeType.new(mimetype, extensions).create
    end
    #
    # read existing mimetype by mimetype
    # @return MimeType if exist, nil else
    #
    def self.get(mimetype)
      m = nil
      begin
        document = @@collection.get_document(attributes: {mimetype: mimetype})
        m = MimeType.new(document, []) if document
      rescue Arango::Error => e
      end
      m
    end

    #
    # read existing mimetype by id
    # @return MimeType if exist, nil else
    #
    def self.get_by_id(id)
      m = nil
      if id
        begin
          document = @@collection.get_document(key: id)
          m = MimeType.new(document, [])
        rescue Arango::Error => e
        end
      end
      m
    end
    #
    # find mimetype
    # @returns MimeType document if found, nil else
    #
    def self.find(mimetype)
      @@collection.get_document(attributes: {mimetype: mimetype})
    end
    #
    # does mimetype exist
    # @returns Boolean
    #
    def self.exists?(mimetype)
      !!self.find(mimetype)
    end

    #
    # instance level
    #
    attr_reader :id, :mimetype, :extensions
    def initialize arg, extensions
#      Logger.info "MimeType#new #{arg.inspect},#{extensions.inspect}"
      case arg
      when Arango::Document::Base
        @id = arg.key
        @mimetype = arg.mimetype
        @extensions = arg.extensions rescue nil
      when String
        @mimetype = arg.downcase
        @extensions = extensions
        mt = MimeType.find(@mimetype)
        @id = (mt) ? mt.key : nil
      else
        raise "Expecting string name instead of #{arg.class}"
      end
    end

    def created?
      !@id.nil?
    end
    alias loaded? created?

    #
    # create MimeType in collection
    # @returns MimeType
    def create
      attrs = { mimetype: @mimetype }
      attrs[:extensions] = @extensions if @extensions # blobs don't have extensions
      document = @@collection.create_document(attributes: attrs)
      @id = document.key
#      Logger.info("MimeType#create #{attrs[:mimetype]} = #{@id}")
      self
    end
    def delete
      @@collection.delete_document(attributes: {mimetype: @mimetype})
      @id = nil
    end
  end
end

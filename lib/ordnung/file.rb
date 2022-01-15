#
# File
#
# representing a file
#
#

require 'ordnung/directory'
require 'ordnung/mime_type'
require 'ordnung/edge'
require 'digest'
require 'open3'

module Ordnung
  class File
    COLLECTION_NAME = "Files"
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
      @@collection = if database.collection_exists?(name: COLLECTION_NAME)
                       database.get_collection(name: COLLECTION_NAME)
                     else
                       database.create_collection(name: COLLECTION_NAME)
                     end
      @@indexes ||= Array.new
      @@indexes << @@collection.create_index(type: "hash", fields: "checksum")
    end
    def self.cleanup
      @@indexes.each do |i|
        begin
          @@collection.delete_index index: i
        rescue
        end
      end
      @@database.delete_collection(name: COLLECTION_NAME) rescue nil
    end

    #
    # @returns number of entries in collection
    #
    def self.count
      @@collection.count rescue nil
    end

    # path component to strip
    def self.strip= pathname
      Directory.strip = pathname
    end
    def self.strip
      Directory.strip
    end

    private

    #
    # return Hash of {name, mimetype_id, directory_id, size, checksum}
    def self._from_pathname pathname
      name = nil
      mimetype_id = nil
      directory_id = nil
      size = nil
      checksum = nil
      if ::File.directory?(pathname)
        raise "File #{pathname.inspect} is a directory"
      end
      unless ::File.exist?(pathname)
        raise "File #{pathname.inspect} does not exist from #{Dir.pwd}"
      end
      unless ::File.readable?(pathname)
        raise "File #{pathname.inspect} is not readable from #{Dir.pwd}"
      end
      size = ::File.size(pathname)
      # less 4MB => in-memory checksum
      if size < 4 * 1024 * 1024
        buf = ::File.read(pathname)
        checksum = Digest::SHA2.hexdigest(buf)
      else
        # spawn "sha256sum"
        cmd = "sha256sum #{pathname}"
        ::Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          exit_status = wait_thr.value # Process::Status object returned.
          if (exit_status.exited?)
            checksum = stdout.read.split(' ').first
          else
            raise "#{cmd.inspect} failed with #{stderr.read.chomp.inspect}"
          end
        end
      end
      name = ::File.basename(pathname)
      dirname = ::File.dirname(pathname)
      mimetype_id = MimeType.match(name).id
      directory_id = Directory.create?(dirname).id
      { name: name, mimetype_id: mimetype_id, directory_id: directory_id, size: size, checksum: checksum }
    end

    public

    #
    # class level 
    #

    #
    # get File by id or key
    # @returns File
    #
    def self.get(id)
      db, key = id.split '/'
      if db
        if key
          # Files/xxx
          return nil unless db == COLLECTION_NAME
        else
          # xxx
          key = db
        end
      else
        # nothing
        return nil
      end
      begin
        document = @@collection.get_document(key: key)
      rescue Arango::Error => e
        return nil
      end
      File.new(document)
    end

    #
    # list Files with offset and limit
    #
    def self.list(offset:, limit:)
      @@collection.list_documents(offset: offset.to_i, limit: limit.to_i)
    end
    #
    # create pathname if needed
    # @param pathname
    # @returns File
    #
    def self.create?(pathname)
      f = self.find(pathname)
      (f) ? f : self.new(pathname).create!
    end

    #
    # find pathname
    # @param pathname
    # @returns File
    #
    def self.find(pathname)
      f = File.new(pathname)
      @@collection.get_document(attributes: { name: f.name, mimetype_id: f.mimetype_id, directory_id: f.directory_id })
    end

    #
    # did we already import this file
    # @param pathname
    # @returns Boolean
    #
    def self.exists?(pathname)
      !!self.find(pathname)
    end

    #
    # return known duplicates (based on checksum)
    #
    # @param pathname
    # @returns id Array of duplicates, empty Array if no duplicates exits
    #
    def self.duplicates(pathname)
      f = File.new(pathname)
      @@collection.get_documents({ checksum: f.checksum }).map {|d| self.new d }
    end

    #
    # find files by tag
    #
    def self.find_by_tag(tag)
      Edge.find_all_files(tag)
    end

    #
    # instance level functions
    #
    attr_reader :id, :key, :name, :directory_id, :size, :checksum, :mimetype_id
    def initialize arg
      case arg
      when Arango::Document::Base
        @id = arg.id
        @key = arg.key
        @name = arg.name
        @mimetype_id = arg.mimetype_id
        @directory_id = arg.directory_id
        @size = arg.size
        @checksum = arg.checksum
      when String
        h = File._from_pathname arg
        @name = h[:name]
        @mimetype_id = h[:mimetype_id]
        @directory_id = h[:directory_id]
        @size = h[:size]
        @checksum = h[:checksum]
        @id = @key = nil
      else
        raise "Unknown argument #{arg.class}:#{arg}"
      end
    end

    def to_s
      "#{@directory_id}/#{@name}<#{@size}>"
    end

    # for <Array of File>.include? <File>
    def == file
      self.id <=> file.id
    end

    def to_hash
      { key: @key, name: @name, mimetype_id: @mimetype_id, directory_id: @directory_id, size: @size }
    end

    def created?
      !@key.nil?
    end
    alias loaded? created?

    def create!
      attrs = { name: @name, directory_id: @directory_id, size: @size, mimetype_id: @mimetype_id, checksum: @checksum }
      document = @@collection.create_document(attributes: attrs)
      @id = document.id
      @key = document.key
      self
    end
    def create?
      attrs = { name: @name, directory_id: @directory_id, size: @size, mimetype_id: @mimetype_id, checksum: @checksum }
      if @@collection.document_exists?(attributes: attrs)
        @@collection.get_document(attributes: attrs)
      else
        create!
      end
    end
    def update
    end
    def delete
      @@collection.delete_document(key: @key)
      @id = @key = nil
    end
    def mimetype
      @mimetype ||= MimeType.get_by_id(@mimetype_id)
    end
    def directory
      @directory ||= Directory.get_by_id(@directory_id)
    end
    #
    # tagging
    #
    def tag t
      raise "File must be created for tagging" unless created?
      edge = Edge.new(t, self).create?
    end
    #
    # find all tags for this file
    #
    def find_all_tags
      Edge.find_all_tags(self)
    end
  end
end

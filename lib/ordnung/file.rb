#
# File
#
# representing a file
#
#

require 'ordnung/directory'
require 'ordnung/mime_type'
require 'digest'
require 'open3'

module Ordnung
  class File
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
      @@collection = if database.collection_exists?(name: "Files")
                       database.get_collection(name: "Files")
                     else
                       database.create_collection(name: "Files")
                     end
    end
    def self.cleanup
      @@database.delete_collection(name: "Files") rescue nil
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
    # get File by id
    # @returns File
    #
    def self.get(id)
      begin
        document = @@collection.get_document(key: id)
      rescue Arango::Error => e
        return nil
      end
      File.new(document)
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
      @@collection.get_document(attributes: { checksum: f.checksum })
    end

    #
    # instance level functions
    #
    attr_reader :id, :name, :directory_id, :size, :checksum, :mimetype_id
    def initialize arg
      case arg
      when Arango::Document::Base
        @id = arg.key
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
        @id = nil
      else
        raise "Unknown argument #{arg.class}:#{arg}"
      end
    end

    def created?
      !@id.nil?
    end
    alias loaded? created?

    def create!
      attrs = { name: @name, directory_id: @directory_id, size: @size, mimetype_id: @mimetype_id, checksum: @checksum }
      document = @@collection.create_document(attributes: attrs)
      @id = document.key
      self
    end
    def update
    end
    def delete
      @@collection.delete_document(key: @id)
      @id = nil
    end
    def mimetype
      @mimetype ||= MimeType.get_by_id(@mimetype_id)
    end
    def directory
      @directory ||= Directory.get_by_id(@directory_id)
    end
  end
end

#
# Tag
#
# representing a tag
#
#

require 'open3'

module Ordnung
  class Tag
    COLLECTION_NAME = "Tags"
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
      @@indexes << @@collection.create_index(type: "hash", fields: "name")
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

    #
    # class level 
    #

    #
    # get Tag by id
    # @returns Tag
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
      Tag.new(document)
    end

    #
    # list Tags with offset and limit
    #
    def self.list(offset:, limit:)
      @@collection.list_documents(offset: offset.to_i, limit: limit.to_i)
    end
    #
    # create tag if needed
    # @param tag name
    # @returns Tag
    #
    def self.create?(tagname)
      f = self.find(tagname)
      (f) ? f : self.new(tagname).create!
    end

    #
    # find tagname
    # @param tagname
    # @returns Tag
    #
    def self.find(tagname)
      @@collection.get_document(attributes: { name: tagname })
    end

    #
    # did we already create this tag ?
    # @param tagname
    # @returns Boolean
    #
    def self.exists?(tagname)
      !!self.find(tagname)
    end

    #
    # instance level functions
    #
    attr_reader :id, :name
    def initialize arg
      case arg
      when Arango::Document::Base
        @id = arg.id
        @name = arg.name
      when String
        @name = arg
        @id = nil
      else
        raise "Unknown argument #{arg.class}:#{arg}"
      end
    end

    def to_s
      "tag<#{@name}>"
    end

    def to_hash
      { id: @id, name: @name }
    end

    def == tag
      if self.id
        self.id == tag.id
      else
        self.name == tag.name
      end
    end

    def created?
      !@id.nil?
    end
    alias loaded? created?

    def create!
      attrs = { name: @name }
      document = @@collection.create_document(attributes: attrs)
      @id = document.id
      self
    end
    def create?
      attrs = { name: @name }
      if @@collection.document_exists?(attributes: attrs)
        @@collection.get_document(attributes: attrs)
      else
        create!
      end
    end
    def update
    end
    def delete
      @@collection.delete_document(key: @id)
      @id = nil
    end
    #
    # find all the files with this tag
    # @returns Array of File
    #
    def find_all_files
      Edge.find_files_matching(self)
    end
  end
end

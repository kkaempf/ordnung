module Ordnung
  #
  # Tagging
  #
  # representing a tagging
  # Tagging is two Indices
  # 1. Name of +Tag+ foo:bar:baz as Gizmo foo <-parent- Gizmo bar <-parent- Gizmo baz
  # 2. +Tagging+ (here) is a Gizmo (Tag) -> Gizmo (File) relationship
  #
  # see also +Tag+
  #
  class Tagging
    #
    # Database index name
    #
    def self.index
      @@index ||= "ordnung-taggings"
    end
    #
    # set index (for testing)
    #
    def self.index= idx
      @@index = idx
    end
    #
    # properties of a tagging, linking a +Tag+ with a +File+ (representing an on-disk file)
    #
    def self.properties
      {
        tag:  { type: "keyword"}, # from tag
        file: { type: "keyword"}  # to file
      }
    end
    #
    # ensure startup order
    #
    def self.init
      Ordnung::Db.properties = self.properties
      Ordnung::Db.create_index self.index
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Database methods
    #
    
    #
    # make logger accessible inside class
    #
    def log
      Ordnung::logger
    end
    #
    # get index name associated with Tags
    # @return +index+
    #
    def index
      Tagging.index
    end
    #
    #
    # Convert instance variables to Hash
    #
    def to_hash
      { tag_id: @tag_id, file_id: @file_id }
    end
    #
    # update or insert
    # @return
    #
    def upsert
      hash = to_hash
      @id = Ordnung::Db.by_hash index, hash
#     log.info "upsert #{hash.inspect} -> #{@id}"
      return if @id
      @id = Ordnung::Db.create index, hash
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Instance methods
    #
    
    #
    # create new Tag object, linking +tag+ with +file+
    #
    def initialize tag, file
#     log.info "Tagging.new(tag #{tag} <-> file #{file})"
      @tag_id = tag.id
      @file_id = file.id
      upsert
    end
    #
    # @return tag id
    #
    def tag_id
      @tag_id
    end
    #
    # return self ?!
    #
    def tag
      Ordnung::Tag.by_id @tag_id
    end
    #
    # @return +id+ of file
    #
    def file_id
      @file_id
    end
    #
    # @return +file+
    #
    def file
      Ordnung::File.by_id @file_id
    end
  end
end

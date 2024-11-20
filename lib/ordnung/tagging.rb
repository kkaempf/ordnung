module Ordnung
  #
  # Tagging
  #
  # representing a tagging
  # Tagging is two Indices
  # 1. Name of tag foo:bar:baz as Gizmo foo <-parent- Gizmo bar <-parent- Gizmo baz
  # 2. Tagging is a Gizmo -> Gizmo relationship
  #

  class Tagging
    #
    # make logger accessible inside class
    #
    def self.log
      Ordnung::logger
    end
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
    # database properties (aka type mapping)
    #
    def self.properties
      {
        tag:   { type: "keyword"}, # from tag
        gizmo: { type: "keyword"}  # to gizmo
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
      { tag_id: @tag_id, gizmo_id: @gizmo_id }
    end
    #
    # update or insert
    # @return
    #
    def upsert
      hash = to_hash
      @id = Ordnung::Db.by_hash index, hash
#      Gizmo.log.info "upsert #{hash.inspect} -> #{@id}"
      return if @id
      @id = Ordnung::Db.create index, hash
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Instance methods
    #
    
    #
    # create new Tag object, linking +tag+ with +gizmo+
    #
    def initialize tag, gizmo
#      Gizmo.log.info "Tagging.new(tag #{tag} <-> gizmo #{gizmo})"
      @tag_id = tag.id
      @gizmo_id = gizmo.id
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
    # @return +id+ of gizmo
    #
    def gizmo_id
      @gizmo_id
    end
    #
    # @return +gizmo+
    #
    def gizmo
      Ordnung::Gizmo.by_id @gizmo_id
    end
  end
end

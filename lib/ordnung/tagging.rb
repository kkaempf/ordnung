#
# Tagging
#
# representing a tagging
# Tagging is two Indices
# 1. Name of tag foo:bar:baz as Gizmo foo <-parent- Gizmo bar <-parent- Gizmo baz
# 2. Tagging is a Gizmo -> Gizmo relationship
#

module Ordnung
  class Tagging
    #
    # logger
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
    # set index (for testing)
    def self.index= idx
      @@index = idx
    end
    def self.properties
      {
        tag:   { type: "keyword"}, # from tag
        gizmo: { type: "keyword"}  # to gizmo
      }
    end
    def self.init
      Ordnung::Db.properties = self.properties
      Ordnung::Db.create_index self.index
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Database methods
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
    def initialize tag, gizmo
#      Gizmo.log.info "Tagging.new(tag #{tag} <-> gizmo #{gizmo})"
      @tag_id = tag.id
      @gizmo_id = gizmo.id
      upsert
    end
    def tag_id
      @tag_id
    end
    def tag
      Ordnung::Tag.by_id @tag_id
    end
    def gizmo_id
      @gizmo_id
    end
    def gizmo
      Ordnung::Gizmo.by_id @gizmo_id
    end
  end
end

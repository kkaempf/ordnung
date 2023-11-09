#
# Tag
#
# representing a tag
# Tagging is two Indices
# 1. Name of tag foo:bar:baz as Gizmo foo <-parent- Gizmo bar <-parent- Gizmo baz
# 2. Tagging is a Gizmo -> Gizmo relationship
#

module Ordnung
  class Tag < Gizmo
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
      "ordnung-tags"
    end
    def self.properties
      {
        from: { type: "keyword"}, # from tag
        to:   { type: "keyword"}  # to gizmo
      }
    end
    def self.init
      Ordnung::Db.properties = self.properties
      Ordnung::Db.index = self.index
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Database methods
    #
    def index
      Tag.index
    end
    #
    #
    # Convert instance variables to Hash
    #
    def to_hash
      { from: @id, to: @to }
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Instance methods
    #
    def initialize name, parent_id=nil
      super name, parent_id
      upsert
    end
    def tag_gizmo gizmo_id
      raise "No existant tag" if @id.nil?
      @to = gizmo_id
      hash = to_hash
      unless Ordnung::Db.by_hash index, hash
        Gizmo.log.info "Tag.upsert #{hash.inspect}"
        Ordnung::Db.create index, hash
      end
    end
    def untag_gizmo gizmo_id
    end
    #
    # return Iterator over all Gizmos with this tag
    def each_gizmo
    end
  end
end

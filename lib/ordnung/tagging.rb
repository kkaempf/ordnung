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
    @@index = "ordnung-taggings"
    #
    # Database index name
    #
    def self.index
      @@index
    end
    #
    # set index (for testing)
    #
    def self.index= idx
      @@index = idx
    end
    #
    # properties of a tagging, linking a +Tag+ with a +Gizmo+
    #
    def self.properties
      {
        tag_id:  { type: "keyword"}, # from tag
        gizmo_id: { type: "keyword"}  # to gizmo
      }
    end
    #
    # ensure startup order
    #
    def self.db= db
      @@db = db
      @@db.create_index self.index, self.properties
   end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    private
    #
    # update or insert
    # @return
    #
    def upsert
      log.info "Tagging.upsert(tag #{@tag_id.inspect} <-> gizmo #{@gizmo_id.inspect})"
      hash = { tag_id: @tag_id, gizmo_id: @gizmo_id }
      @self_id = @@db.by_hash index, hash
#     log.info "Tagging.upsert #{hash.inspect} -> #{@id}"
      return if @self_id
      @self_id = @@db.create index, hash
    end
    public
    #
    # Database methods
    #
    def log
      ::Ordnung.logger
    end
    #
    # get index name associated with Tags
    # @return +index+
    #
    def index
      Tagging.index
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    attr_reader :self_id, :tag_id, :gizmo_id
    #
    # Instance methods
    #
    def == other
      other &&
        @tag_id == other.tag_id &&
        @gizmo_id == other.gizmo_id
    end
    #
    # create new Tag object, linking +tag+ with +gizmo+
    #
    def initialize tag, gizmo
      log.info "Tagging.new(tag #{tag.inspect} <-> gizmo #{gizmo.inspect})"
      @tag_id = tag.self_id
      @gizmo_id = gizmo.self_id
      upsert
    end
    #
    # @return +id+ of Tag
    #
    def tag_id
      @tag_id
    end
    #
    # return +Tag+
    #
    def tag
      log.info "Tagging.tag #{@tag_id.inspect}"
      Tag.by_id @tag_id
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
      log.info "Tagging.gizmo #{@gizmo_id.inspect})"
      Gizmo.by_id @gizmo_id
    end
  end
end

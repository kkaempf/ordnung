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
      log.info "Tagging.upsert(#{@self_id.inspect}:#{@properties.inspect})"
      unless @self_id
        id = @@db.id_by_properties @@index, @properties
        unless id
          id = @@db.create @@index, @properties
        end
        id
      end
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    public
    #
    # Database methods
    #
    def log
      ::Ordnung.logger
    end
    def method_missing prop
      @properties[prop.to_s]
    end
    #
    attr_reader :properties, :self_id
    #
    # Instance methods
    #
    def == other
      other &&
        self.class == other.class &&
        @self_id == other.self_id &&
        @properties == other.properties
    end
    #
    # return +Tag+
    #
    def tag
      Tag.by_id self.tag_id
    end
    #
    # @return +gizmo+
    #
    def gizmo
      Gizmo.by_id self.gizmo_id
    end
    #
    # create new Tag object, linking +tag+ with +gizmo+
    #
    def initialize tag, gizmo
      log.info "Tagging.new(tag #{tag.inspect} <-> gizmo #{gizmo.inspect})"
      @properties = { 'tag_id' => tag.self_id, 'gizmo_id' => gizmo.self_id }
      @self_id = upsert
    end
  end
end

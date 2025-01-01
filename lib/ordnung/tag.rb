#
# Tag namespace: `Ordnung::Tag`
#
module Ordnung
  #
  # Tag - a label Name and a parent Tag
  #
  # representing a tag
  # +Tagging+ is two Indices
  # 1. Name of +Tag+ (here) foo:bar:baz as tag foo <-parent- tag bar <-parent- tag baz
  # 2. +Tagging+ is a Tag <-> Gizmo relationship
  #
  # see also +Tagging+
  #
  class Tag
    @@index = "ordnung-tags"
    #
    # make log accessible
    #
    def self.log
      ::Ordnung::logger
    end
    #
    # make log accessible
    #
    def log
      ::Ordnung::logger
    end
    #
    # connect Tag to Database
    #
    def self.db= db
      @@db = db
      db.create_index self.index, self.properties
    end
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
    # properties of a tag, linking a +Tag+ with a +Name+ and a parent +Tag+
    #
    def self.properties
      {
        name_id: { type: "keyword"},
        parent_id: { type: "keyword"}
      }
    end
    #
    # retrieve +Tag+ from id
    # @return +Tag+ or nil
    #
    def self.by_id id
      log.info "Tag.by_id(#{id.inspect})"
      return nil if id.nil?
      properties = @@db.properties_by_id(Tag.index, id)
      log.info "\tTag.by_id(#{properties.inspect})"
      tag = nil
      if properties
        tag = Tag.new(properties)
        tag.set_id id
      end
      tag
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Instance methods
    #
    def == other
      other &&
        @name.self_id == other.name.self_id &&
        @parent_id == other.parent_id
    end
    #
    # retrieve full name of tag
    #
    def fullname
      log.info "Tag.fullname(#{@name.name.inspect}, #{@parent_id.inspect})"
      ((@parent_id)?"#{Tag.by_id(@parent_id).fullname}:":"") + @name.name
    end
    #
    #
    #
    def set_id id
      @self_id = id
    end
    # tag id
    # tag name
    # id of parent tag
    attr_reader :self_id, :name, :parent_id
    #
    # create new Tag instance
    #
    def initialize name, parent_id=nil
      raise "Database not set" if @@db.nil?
      case name
      when String # from string constant
        elements = name.split(':')
        last = elements.pop
        log.info "Tag.new(#{name.inspect} -> #{elements.inspect} + #{last.inspect})"
        elements.each do |element|
          tag = Tag.new(element, parent_id)
          parent_id = tag.self_id
        end
        @self_id = nil
        @name = Name.new last
        @parent_id = parent_id
      when Name # from Name
        log.info "Tag.new(#{name.inspect})"
        @self_id = nil
        @name = name
        @parent_id = nil
      when Hash # from database
        log.info "Tag.new(#{name.inspect}, #{parent_id.inspect})"
        @self_id = parent_id
        @name = Name.by_id(name['name_id'])
        @parent_id = name['parent_id']
      end
      if @self_id.nil? # not from database
        properties = { 'name_id' => @name.self_id, 'parent_id' => @parent_id }
        @self_id = @@db.id_by_properties(Tag.index, properties)
        if @self_id.nil? # does not exist
          # upsert !
          @self_id = @@db.create(Tag.index, properties)
        end
      end
    end
  end
end

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
    #
    # make log accessible
    #
    def self.log
      Ordnung::logger
    end
    #
    # make log accessible
    #
    def log
      Ordnung::logger
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
      @@index ||= "ordnung-tags"
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
    def self.from_id id
      log.info "Tag.from_id(#{id.inspect})"
      return nil if id.nil?
      begin
        hash = @@db.by_id(Tag.index, id)
        log.info "    Tag.from_id(hash #{hash.inspect})"
        Tag.new(hash, id) if hash
      rescue
        nil
      end
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Instance methods
    #

    #
    # retrieve full name of tag
    #
    def fullname
      log.info "Tag.fullname(#{@name.name.inspect}, #{@parent_id.inspect})"
      ((@parent_id)?"#{Tag.from_id(@parent_id).fullname}:":"") + @name.name
    end
    attr_reader :id, :name, :parent_id
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
          parent_id = tag.id
        end
        @id = nil
        @name = Name.new last
        @parent_id = parent_id
      when Name # from Name
        log.info "Tag.new(#{name.inspect})"
        @id = nil
        @name = name
        @parent_id = nil
      when Hash # from database
        log.info "Tag.new(#{name.inspect}, #{parent_id.inspect})"
        @id = parent_id
        @name = Name.from_id(name['name_id'])
        @parent_id = name['parent_id']
      end
      if @id.nil? # not from database
        hash = { name_id: @name.id, parent_id: @parent_id }
        @id = @@db.by_hash(Tag.index, hash)
        if @id.nil? # does not exist
          @id = @@db.create(Tag.index, hash)
        end
      end
    end
  end
end

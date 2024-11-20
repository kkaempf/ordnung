#
# Tag namespace: `Ordnung::Tag`
#
module Ordnung
  #
  # Tag - a label identifying files
  #
  # representing a tag
  # +Tagging+ is two Indices
  # 1. Name of +Tag+ (here) foo:bar:baz as Gizmo foo <-parent- Gizmo bar <-parent- Gizmo baz
  # 2. +Tagging+ is a Gizmo -> Gizmo relationship
  #
  # see also +Tagging+
  #
  class Tag < Gizmo
    #
    # make logger available inside +Tag+
    #
    def self.log
      Ordnung::logger
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
    # ensure database initialization order
    #
    def self.init
      super
      Ordnung::Db.create_index self.index
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Instance methods
    #
    
    #
    # create new Tag instance
    #
    def initialize name, id=nil
#      Gizmo.log.info "Tag.new(#{name.inspect})"
      super name
      case name
      when String
        @name = name
        elements = name.split(':')
        last = elements.pop
        parent_id = nil
        elements.each do |element|
          gizmo = Gizmo.new(element, parent_id)
          parent_id = gizmo.upsert
        end
        super last, parent_id
        @id = upsert
      when Hash
        @id = id
        @name = name['@name']
      end
    end
    #
    # @return +name+ of Tag
    #
    def name
      @name
    end
    #
    # @return +id+ of Tag
    #
    def id
      @id
    end
    #
    # @return Iterator over all Gizmos with this tag
    #
    def each_gizmo
    end
  end
end

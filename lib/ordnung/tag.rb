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
      @@index ||= "ordnung-tags"
    end
    # set index (for testing)
    def self.index= idx
      @@index = idx
    end
    def self.init
      super
      Ordnung::Db.create_index self.index
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Instance methods
    #
    def initialize name, id=nil
      Gizmo.log.info "Tag.new(#{name.inspect})"
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
    def name
      @name
    end
    def id
      @id
    end
    #
    # return Iterator over all Gizmos with this tag
    def each_gizmo
    end
  end
end

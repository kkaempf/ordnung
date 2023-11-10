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
      Ordnung::Gizmo.init
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Instance methods
    #
    def initialize name
#      Gizmo.log.info "Tag.new(#{name.inspect}"
      @name = name
      elements = name.split(':')
      last = elements.pop
      parent_id = nil
      elements.each do |element|
#        Gizmo.log.info "-> Gizmo.new(#{element.inspect} -> #{parent_id.inspect}"
        gizmo = Gizmo.new(element, parent_id)
        parent_id = gizmo.upsert
      end
#      Gizmo.log.info "-> last Gizmo.new(#{last.inspect} -> #{parent_id.inspect}"
      super last, parent_id
      @id = upsert
#      Gizmo.log.info "==> id #{@id.inspect}"
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

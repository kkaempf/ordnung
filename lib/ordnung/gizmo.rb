require_relative 'name'
require 'pathname'

module Ordnung
  #
  # A Gizmo is the core item of Ordnung.
  #
  # It is a string representation in the database with an associated database id for quick access
  # and a parent for implementing a file system or tag hierachy
  #
  #
  class Gizmo
    @@index = "ordnung-gizmos"

    def log
      ::Ordnung.logger
    end
    def self.log
      ::Ordnung.logger
    end
    private
    #
    # Database index name
    #
    def self.index
      @@index
    end
    # set index (for testing)
    def self.index= idx
      @@index = idx
    end
    #
    # find Gizmo id by pattern
    # @return id
    #
    def self.find pattern
      case pattern
      when String
        id = Name.by_name pattern
      else
        nil
      end
    end
    #
    # connect Gizmo to Database
    #
    def self.db= db
      @@db = db
      @@db.create_index self.index, self.properties
    end
    #
    # Database type mapping
    #
    def self.properties
      {
        :class =>     { type: 'keyword' },
        :name_id =>   { type: 'keyword' },
        :parent_id => { type: 'keyword' },
        :added_at =>  { type: 'date', doc_values: true }
      }
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    public
    #
    # Gizmo by Properties
    # @return gizmo
    #
    def self.by_properties properties
      log.info "Gizmo.by_properties #{properties.inspect}"
      klass = "::#{properties['class']}"
      (eval klass).new properties
    end
    #
    # Gizmo by id
    # @return gizmo
    #
    def self.by_id id
      raise "No id given" if id.nil?
      properties = @@db.properties_by_id(@@index, id)
#      log.info "Gizmo.by_id #{id} -> #{hash.inspect}"
      gizmo = if properties
                self.by_properties properties
              else
                nil
              end
      gizmo.set_id(id) if gizmo
      gizmo
    end
    #
    # iterator
    #
    def self.each options={}, &block
      @@db.each @@index, options, &block
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # update or insert
    # @return id
    #
    def upsert
      return if @self_id
      id = @@db.id_by_properties @@index, @properties
      log.info "Gizmo.upsert #{@properties.inspect} -> #{id}"
      unless id
        # create new in database
        @properties['added_at'] = @added_at = Time.now.to_i
        @properties['class'] = "#{self.class}"
        id = @@db.create @@index, @properties
      end
      @self_id = id
    end
    #
    # @return string representation of +Gizmo+
    #
    def to_s
      "#{self.class}(#{@self_id}:#{@properties.inspect})"
    end
    #
    # equality operator
    #
    def == other
      other &&
        self.class == other.class &&
        @self_id == other.self_id &&
        @properties == other.properties
    end
    #
    # @return name of Gizmo as string
    #
    def name
      log.info "#{self.class}.name #{@properties.inspect}"
      n_id = self.name_id
      raise "No name" if n_id.nil?
      Name.by_id(n_id).name
    end
    #
    # File helper method
    # (re-)create full path  /dir <-parent- dir <-parent- ...
    #
    def path
      p_id = self.parent_id
      if p_id
        begin
          n = self.name
          ppath = Gizmo.by_id(p_id).path
          ::File.join(ppath, n)
        rescue
          log.info "*** Gizmo.path(#{@properties.inspect}:#{ppath.inspect} / #{n.inspect})"
          raise
        end
      else
        "/#{self.name}"
      end
    end
    #
    # Gizmo#has? tag
    # @return Boolean
    #
    def has? tag
      tag.to? @self_id
    end
    #
    # Gizmo#tag! tag
    # add tag to gizmo
    #
    def tag tg
      tg.tag @self_id
    end
    #
    # Gizmo#untag! tag
    # remove tag from gizmo
    #
    def untag tag
      tag.untag @self_id
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # properties access
    #
    def method_missing prop
      @properties[prop] || @properties[prop.to_s]
    end
    def set_id id
      @self_id = id
    end
    #
    attr_reader :properties, :self_id
    #
    # Gizmo#new
    #
    def initialize props, parent_id=nil
      log.info "Gizmo.new(#{props.inspect},#{parent_id.inspect})"
      case props
      when String, Pathname
        Gizmo.log.info "Gizmo.new from String or Pathname"
        @properties = { 'name_id' => Name.new(props).self_id, 'parent_id' => parent_id }
      when Hash
        Gizmo.log.info "Gizmo.new from Properties"
        @properties = props
      else
        raise "Can't create Gizmo from #{props.inspect}"
      end
    end
  end
end

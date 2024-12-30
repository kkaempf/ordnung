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
        :added_at =>  { type: 'date', format: 'yyyy-MM-dd HH:mm:ss Z' } # 2023-11-08 16:03:40 +0100
      }
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    public
    #
    # Gizmo by id
    # @return gizmo
    #
    def self.by_id id
      raise "No id given" if id.nil?
      hash = @@db.by_id(@@index, id)
#      log.info "Gizmo.by_id #{id} -> #{hash.inspect}"
      if hash
        log.info "Gizmo.by_id hash #{hash.inspect}"
        klass = "::#{hash['class']}"
        (eval klass).new hash, id
      else
        nil
      end
    end
    #
    #
    # Convert instance variables to Hash
    #
    def to_hash
      log.info "Gizmo.to_hash"
    end
    #
    # update or insert
    # @return id
    #
    def upsert hash={}
      hash.merge!({ name_id: @name_id, parent_id: @parent_id, added_at: @added_at })
      @self_id = @@db.by_hash @@index, hash
      log.info "Gizmo.upsert #{hash.inspect} -> #{@self_id}"
      return if @self_id
      # create new Gizmo
      hash[:added_at] = @added_at = Time.now.floor
      hash[:class] = self.class
      @self_id = @@db.create @@index, hash
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # @return string representation of +Gizmo+
    #
    def to_s
      "Gizmo(#{@name}:#{@self_id}->#{@parent_id})"
    end
    #
    # equality operator
    #
    def == other
      other &&
        self.class == other.class &&
        @name_id == other.name_id &&
        @parent_id == other.parent_id &&
        @added_at == other.added_at
    end
    #
    # @return name of Gizmo as string
    #
    def name
      raise "No name" if @name_id.nil?
      Name.by_id(@name_id).name
    end
    #
    # File helper method
    # (re-)create full path  /dir <-parent- dir <-parent- ...
    #
    def path
      if @parent_id
        begin
          ppath = Gizmo.by_id(@parent_id).path
          ::File.join(ppath, name)
        rescue
          Gizmo.log.info "*** Gizmo.path(#{ppath.inspect} / #{name.inspect})"
          raise
        end
      else
        "/#{name}"
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
    # id of name and parent gizmo
    # timestamp of creation
    attr_reader :self_id, :name_id, :parent_id, :added_at
    #
    # Gizmo#new
    #
    def initialize name, parent_id=nil
      log.info "Gizmo.new(#{name.inspect},#{parent_id.inspect})"
      case name
      when String, Pathname
#        Gizmo.log.info "Gizmo.new(#{parent_id} / #{name.inspect})"
        @name_id = Name.new(name).self_id
        @parent_id = parent_id
      when Hash
#        Gizmo.log.info "Gizmo.new(#{name.inspect}) -> #{parent_id}"
        @self_id = parent_id
        @parent_id = name['parent_id']
        @name_id = name['name_id']
        @added_at = Time.new(name['added_at'])
      else
        raise "Can't create Gizmo from #{name.inspect}"
      end
#      Gizmo.log.info "\t ==> #{self}"
    end
  end
end

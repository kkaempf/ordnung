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
    private
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
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    public
    #
    # Database methods
    #
    # +index+ name of +Gizmo+ in database
    #
    def index
      Gizmo.index
    end
    #
    # connect Gizmo to Database
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
    # set index (for testing)
    def self.index= idx
      @@index = idx
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
    #
    #
    # Convert instance variables to Hash
    #
    def to_hash
      hash = { name_id: @name_id, parent_id: @parent_id, added_at: @added_at }
#      Gizmo.log.info "#{self}.to_hash #{hash.inspect}"
      hash
    end
    #
    # update or insert
    # @return id
    #
    def upsert
      hash = to_hash
      @id = @@db.by_hash index, hash
#      Gizmo.log.info "upsert #{hash.inspect} -> #{@id}"
      return if @id
      hash[:added_at] = @added_at = Time.now.floor
      hash[:class] = self.class
      @id = @@db.create index, hash
    end
    #
    # Gizmo by id
    # @return gizmo
    #
    def self.by_id id
      raise "No id given" if id.nil?
      hash = @@db.by_id(self.index, id)
#      log.info "Gizmo.by_id #{id} -> #{hash.inspect}"
      gizmo = nil
      if hash
#        log.info "Gizmo.by_id hash #{hash.inspect}"
        klass = hash['class']
        gizmo = (eval klass).new hash, id
      end
      gizmo
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # @return string representation of +Gizmo+
    #
    def to_s
      "Gizmo(#{self.name}->#{@parentId})"
    end
    #
    # equality operator
    #
    def == gizmo
      self.class == gizmo.class &&
        @name_id == gizmo.name_id &&
        @parent_id == gizmo.parent_id &&
        @added_id == gizmo.added_at
    end
    #
    # @return name of Gizmo as string
    #
    def name
      raise "No name" if @name_id.nil?
      Name.from_id(@name_id)
    end
    #
    # @return id of Gizmo
    #
    def id
      @id
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
    attr_reader :name_id, :parent_id, :added_at
    #
    # Gizmo#new
    #
    def initialize name, parent_id=nil
      log.info "Gizmo.new(#{name.class}:#{name})"
      case name
      when String, Pathname
#        Gizmo.log.info "Gizmo.new(#{parent_id} / #{name.inspect})"
        @name_id = Name.new(name).id
        @parent_id = parent_id
        upsert
      when Hash
#        Gizmo.log.info "Gizmo.new(#{name.inspect}) -> #{parent_id}"
        @id = parent_id
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

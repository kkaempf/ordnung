module Ordnung
  #
  # Name
  # maps Strings to Ids
  #
  # A name can be any string, like a filename, a path component, or a tag (resp. part of a tag)
  #
  class Name
    @@index = "ordnung-names"

    def log
      ::Ordnung.logger
    end
    #
    # pass the database instance to the Name class
    #
    def self.db= db
      @@db = db
      db.create_index self.index, self.properties
    end

    #
    # Provide a { name: <string> } hash, ready for database consumption
    #
    def self.to_hash name
      { 'name': name.to_s }
    end
    #
    # The database index associated with Names
    #
    def self.index
      @@index
    end
    #
    # set database index (for testing)
    #
    def self.index= idx
      @@index = idx
    end
    #
    # The value properties (aka type mapping) for Name
    #
    def self.properties
      {
        name: { type: 'keyword' }
      }
    end
    #
    # retrieve +Name+ from id
    # @return +Name+ or nil
    #
    def self.by_id id
      return nil if id.nil?
      properties = @@db.properties_by_id(@@index, id)
      name = properties['name']
      if name
        n = Name.new(name)
        n.set_id id
        n
      else
        nil
      end
    end
    #
    # search id by name
    # @return id
    #
    def self.id_by_name name
      return nil if name.nil?
      id = @@db.id_by_properties(@@index, self.to_hash(name))
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    public

    #
    # test +Name+ equality
    #
    def == other
      @name == other.name && @self_id == other.self_id
    end

    #
    # +String+ representation of +Name+
    #
    def to_s
      "Name(#{@name.inspect}@#{@self_id.inspect})"
    end

    #
    #
    #
    def set_id id
      @self_id = id
    end
    #
    # make id and name accessible
    #
    attr_reader :self_id, :name
    #
    # create new +Name+ (or load from db)
    #
    #
    def initialize name, id=nil
      log.info "Name.new(#{name.inspect}, #{id.inspect})"
      raise "Name cannot be nil" if name.nil?
      @name = name
      if id
        @self_id = id
      else
        id = Name.id_by_name(name)
        if id
          @self_id = id
        else
          @self_id = @@db.create(Name.index, Name.to_hash(@name))
        end
      end
    end
  end
end

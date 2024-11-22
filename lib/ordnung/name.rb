module Ordnung
  #
  # Name
  # maps Strings to Ids
  #
  # A name can be any string, like a filename, a path component, or a tag (resp. part of a tag)
  #
  class Name
    #
    # make log accessible
    #
    def log
      Ordnung::logger
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
      @@index ||= "ordnung-names"
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
    def self.from_id id
      return nil if id.nil?
      begin
        name = @@db.by_id(index, id)['name']
        Name.new(name, id)
      rescue
        nil
      end
    end
    #
    # search id by name
    # @return id
    #
    def self.id_by_name name
      return nil if name.nil?
      begin
        id = @@db.by_hash(index, self.to_hash(name))
      rescue
        nil
      end
    end

    #
    # test +Name+ equality
    #
    def == other
      @name == other.name && @id == other.id
    end

    #
    # +String+ representation of +Name+
    #
    def to_s
      "Name(#{@name.inspect}@#{@id.inspect})"
    end

    #
    # make id and name accessible
    #
    attr_reader :id, :name
    #
    # create new +Name+ (or load from db)
    #
    #
    def initialize name, id=nil
      log.info "Name.new(#{name.inspect}, #{id.inspect})"
      raise "Name cannot be nil" if name.nil?
      @name = name
      if id
        @id = id
      else
        id = Name.id_by_name(name)
        if id
          @id = id
        else
          @id = @@db.create(Name.index, Name.to_hash(@name))
        end
      end
    end
  end
end

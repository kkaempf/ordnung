module Ordnung
  #
  # Name
  # maps Strings to Ids
  #
  # A name can be any string, like a filename, a path component, or a tag (resp. part of a tag)
  #
  class Name
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
    # ensure startup order
    #
    def self.init
      Ordnung::Db.properties = self.properties
      Ordnung::Db.create_index self.index
    end
    #
    # search name by id
    # @return name
    #
    def self.by_id id
      return nil if id.nil?
      Ordnung::Db.by_id(index, id)['name'] rescue nil
    end
    #
    # search by name
    # @return id
    #
    def self.by_name name
      return nil if name.nil?
      Ordnung::Db.by_hash(index, self.to_hash(name)) rescue nil
    end
    #
    # find or insert a name
    # @return id
    #
    def self.finsert name
      id = self.by_name name
      return id if id
      Ordnung::Db.create(index, self.to_hash(name))
    end
  end
end

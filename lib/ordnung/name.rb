#
# Name
# maps Strings to Ids
#
module Ordnung
  class Name
    def self.to_hash name
      { 'name': name.to_s }
    end
    def self.index
      @@index ||= "ordnung-names"
    end
    # set index (for testing)
    def self.index= idx
      @@index = idx
    end
    def self.properties
      {
        name: { type: 'keyword' }
      }
    end
    def self.init
      Ordnung::Db.properties = self.properties
      Ordnung::Db.create_index self.index
    end
    #
    # search by id
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
    # find or insert
    # @return id
    #
    def self.finsert name
      id = self.by_name name
      return id if id
      Ordnung::Db.create(index, self.to_hash(name))
    end
  end
end

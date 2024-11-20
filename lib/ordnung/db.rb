##
# Database abstraction
#
require 'opensearch'

module Ordnung
  #
  # Backend database
  #
  # Encapsulating all database I/O and the actual database being used.
  #
  # Current database target: OpenSearch (resp. ElasticSearch)
  #
  class Db
    #
    # Db.log makes the 'upstream' log API available inside Db
    #
    def self.log
      Ordnung::logger
    end
    #
    # Create a new database backend instance
    #
    def self.init
      @@client = OpenSearch::Client.new(
        url: "http://localhost:9200",
        retry_on_failure: 5,
        request_timeout: 10,
        log: false
      )
    end
    #
    # (re-)set +properties+
    #
    # properties is a map of { name: type } pairs declaring the +type+ of property +name+
    #
    def self.properties= properties
      log.info "Db.properties = #{properties.inspect}"
      @@properties = properties
    end
    #
    # collect properties
    #
    def self.collect_properties properties
      log.info "Db.collect_properties #{properties.inspect}"
      @@properties.merge!(properties) if properties
    end
    #
    # set index with collected properties
    #
    def self.create_index index
      if @@client.indices.exists?(index: index)
        current_mapping = @@client.indices.get_mapping(index: index)
        log.info "Db.get_mapping(#{index}): #{current_mapping.inspect}"
        current_properties = current_mapping[index]['mappings']['properties'] rescue nil
        log.info "Db.current_properties(#{index}): #{current_properties.inspect}"
        log.info "Db.put_mapping(#{index}): #{@@properties.inspect}"
        @@client.indices.put_mapping(
          index: index,
          body: {
            properties: @@properties
          }
        )
      else
        log.info "Db.create_index(#{index})"
        @@client.indices.create(
          index: index,
          body: {
            mappings: {
              properties: @@properties
            }
          }
        )
      end
    end
    #
    # delete index
    #
    def self.delete_index index
      @@client.indices.delete(index: index) if @@client.indices.exists?(index: index)
    end
    #
    # get record from index by id
    # @return hash
    #
    def self.by_id index, id
      result = @@client.get(index: index, id: id)
      log.info "Db.#{__callee__} #{index.inspect} - #{id.inspect}"
      return nil if result.nil?
      result['_source']
    end
    #
    # get record from index by hash
    # @return id
    #
    def self.by_hash index, hash
      return nil if hash.empty?
      if hash.size == 1
        query = { match: hash }
      else
        filter = []
        hash.each do |key,value|
          next if value.nil?
          filter << { match: { key => value } }
        end
        query = { bool: { filter: filter } }
      end
      log.info "Db.#{__callee__} #{index.inspect} - #{hash.inspect}: #{query.inspect}"
      result = @@client.search(
        index: index,
        body: {
          query: query
        }
      )
      result.dig('hits', 'hits', 0, '_id')
    end
    #
    # create record in index, store hash
    # @return id
    #
    def self.create index, hash
      log.info "#{__callee__}: #{index} #{hash.inspect}"
      result = @@client.create(
        index: index,
        body: hash
      )
      @@client.indices.refresh(index: index)
      result['_id']
    end
  end
end

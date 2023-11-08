#
# Database abstraction
#
require 'opensearch'

module Ordnung
  class Db
    #
    # logger
    #
    def self.log
      Ordnung::logger
    end
    #
    # initialize
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
    # (re-)set properties
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
    def self.index= index
      if @@client.indices.exists?(index: index)
        log.info "Update mapping #{@@properties.inspect}"
        @@client.indices.put_mapping(
          index: index,
          body: {
            properties: @@properties
          }
        )
      else
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
    # get record from index by id
    # @return hash
    #
    def self.by_id index, id
      result = @@client.get(index: index, id: id)
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
#      log.info "by_hash #{hash.inspect}: #{query.inspect}"
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
      result = @@client.create(
        index: index,
        body: hash
      )
      @@client.indices.refresh(index: index)
      result['_id']
    end
  end
end

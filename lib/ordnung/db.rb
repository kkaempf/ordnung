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
        log: true
      )
    end
    #
    # set mapping
    #
    def self.mapping= mapping
      log.info "Db.mapping #{mapping.inspect}"
      return if @@client.indices.exists?(index: mapping[:index])
      @@client.indices.create(
        index: mapping[:index],
        body: {
          mappings: {
            properties: mapping[:properties]
          }
        }
      )
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
      result = @@client.search(
        index: index,
        body: {
          query: {
            match: hash
          }
        }
      )
      hits = result.dig('hits','hits')
      (hits.empty?) ? nil : hits[0]['_id']
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
      id = result['_id']
      @@client.indices.refresh(index: index)
      return id
    end
  end
end

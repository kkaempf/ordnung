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
    def log
      ::Ordnung.logger
    end
    #
    # collect properties
    #
    def collect_properties properties
      @properties.merge!(properties) if properties
    end
    #
    # set index with collected properties
    #
    def create_index index, properties=nil
      log.info "    Db.create_index(#{index}, #{properties.inspect})"
      if @client.indices.exists?(index: index)
        current_mapping = @client.indices.get_mapping(index: index)
        log.info "        Db.get_mapping(#{index}): #{current_mapping.inspect}"
        current_properties = current_mapping[index]['mappings']['properties'] rescue nil
        log.info "        Db.current_properties(#{index}): #{current_properties.inspect}"
        log.info "        Db.put_mapping(#{index}): #{properties.inspect}"
        equal_properties = true
        properties.each do |k,v|
          cv = current_properties[k] || current_properties[k.to_s] # get current value
          if cv.nil?
            log.error "current_properties[#{k.inspect}] is nil"
            next
          end
          if v
            type = v[:type] || v["type"]
            ctype = cv[:type] || cv["type"]
            if ctype == type
              next
            else
              log.info "            #{k}: #{ctype.inspect} != #{type.inspect}"
              equal_properties = false
              break
            end
          else
            log.info "        Key #{k.inspect} not found in current properties"
            equal_properties = false
            break
          end
        end # properties.each
        return if equal_properties
        @client.indices.put_mapping(
          index: index,
          body: {
            properties: properties
          }
        )
      else
        # database index does not exist
        @client.indices.create(
          index: index,
          body: {
            mappings: {
              properties: properties
            }
          }
        )
      end
    end
    #
    # delete index
    #
    def delete_index index
      @client.indices.delete(index: index) if @client.indices.exists?(index: index)
    end
    #
    # get record from index by id
    # @return Hash of properties
    #
    def properties_by_id index, id
      result = @client.get(index: index, id: id)
      log.info "    Db.#{__callee__} #{index.inspect} - #{id.inspect}"
      return nil if result.nil?
      result['_source']
    end
    #
    # get id from index by properties
    # @return id
    #
    def id_by_properties index, properties
      return nil if properties.empty?
      if properties.size == 1
        query = { match: properties }
      else
        filter = []
        properties.each do |key,value|
          next if value.nil?
          next if key == '_id'
          filter << { match: { key => value } }
        end
        query = { bool: { filter: filter } }
      end
      log.info "    Db.#{__callee__} #{index.inspect} - #{properties.inspect}: #{query.inspect}"
      result = @client.search(
        index: index,
        body: {
          query: query
        }
      )
      result.dig('hits', 'hits', 0, '_id')
    end
    #
    # create record in index, store properties
    # @return id
    #
    def create index, properties
      log.info "    Db.#{__callee__}: #{index} #{properties.inspect}"
      result = @client.create(
        index: index,
        body: properties
      )
      @client.indices.refresh(index: index)
      result['_id']
    end
    #
    #
    #
    def each index, options={}, &block
      log.info "Db.each #{index.inspect} #{options.inspect}"
      body = { sort: [ { 'added_at' => { order: 'asc' } } ] }
      unless options.empty?
        query = {}
        klass = options[:klass]
        if klass
          query = { bool: { filter: { match: { 'class' => "#{klass}" } } } }
        end
        unless query.empty?
          body[:query] = query
        end
      end
      from = 0
      loop do
        begin
          log.info "\tclient.search index #{index.inspect}, from #{from}, body #{body.inspect}"
          response = @client.search( index: index, from: from, size: 1, body: body )
          log.info "\tclient.search response #{response.inspect}"
          properties = response.dig('hits', 'hits', 0, '_source')
          break if properties.nil?
          properties[:id] = response.dig('hits', 'hits', 0, '_id')
          yield Gizmo.by_properties(properties)
          from += 1
        rescue Exception => e
          log.warn "search failed with '#{e}'"
          raise
        end
      end
    end
    #
    # Create a new database backend instance
    #
    def initialize logger
      @scroll_id = Hash.new
      begin
        @client = OpenSearch::Client.new(
          url: "http://localhost:9200",
          retry_on_failure: 5,
          request_timeout: 10,
          log: false
        )
        @client.cluster.health
      rescue Exception => e
        log.error "OpenSearch database not running: #{e}"
      end
    end

  end
end

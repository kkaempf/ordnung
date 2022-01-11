#
# Edge
#
# representing an edge
#
#

require 'open3'

module Ordnung
  class Edge
    def self.server
      @@database.server
    end
    def self.database
      @@database
    end
    def self.database= database
      @@database = database
    end
    def self.setup
      @@collection = if database.collection_exists?(name: "Edges")
                       database.get_collection(name: "Edges")
                     else
                       database.create_collection(name: "Edges", type: :edge)
                     end
    end
    def self.cleanup
      @@database.delete_collection(name: "Edges") rescue nil
    end

    #
    # @returns number of entries in collection
    #
    def self.count
      @@collection.count rescue nil
    end

    #
    # class level 
    #

    #
    # get Edge by from, to
    # @returns Edge
    #
    def self.get(from, to)
      begin
        edge = @@collection.get_edge(from.id, to.id)
      rescue Arango::Error => e
        return nil
      end
      Edge.new(edge)
    end

    #
    # list Edges with from and to
    #
    def self.list(from, to)
      @@collection.list_edges(from.id, to.id)
    end
    #
    # create edge if needed
    # @param from, to
    # @returns Edge
    #
    def self.create?(from, to)
      f = self.find(from.id, to.id)
      (f) ? f : self.new(from.id, to.id).create!
    end

    #
    # find edge
    # @param from, to
    # @returns Edge
    #
    def self.find(from, to)
      t = @@collection.get_document(attributes: { from: from.id, to: to.id })
      t ? Edge.new(t) : nil
    end

    #
    # did we already create this edge ?
    # @param from, to
    # @returns Boolean
    #
    def self.exists?(from, to)
      !!self.find(from, to)
    end

    #
    # instance level functions
    #
    attr_reader :from, :to, :id
    def initialize from, to = nil
      if to
        @from = from
        @to = to
      else # to is nil
        case from
        when Arango::Edge::Base
          @from = from.from
          @to = from.to
        else
          raise "Unknown argument #{arg.class}:#{arg}"
        end
      end
    end

    def to_s
      "Edge(#{@from}->#{@to})"
    end

    def to_hash
      { from: @from.id, to: @to.id }
    end

    def created?
      !@id.nil?
    end
    alias loaded? created?

    def create!
      edge = @@collection.create_edge(from: @from.id, to: @to.id)
      @id = edge.key
      self
    end
    def create?
      attrs = self.to_hash
      if @@collection.edge_exists?(attributes: to_hash)
        @@collection.get_edge(@from.id, @to.id)
      else
        create!
      end
    end
    def update
    end
    def delete
      @@collection.delete_edge(key: @id)
      @id = nil
    end
  end
end

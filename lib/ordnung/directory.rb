#
# Directory
#
# representing one directory level with a 'parent' backlink
#  'parent' might be nil to indicate a 'root' directory
#
#

module Ordnung
  class Directory

    #
    # StrippedPath
    #
    class StrippedPath < String
      @@strip = ""
      def self.strip= pathname
        @@strip = self.clean(pathname)
        # attach a trailing slash if not present
        unless @@strip[-1,1] == ::File::SEPARATOR
          @@strip << ::File::SEPARATOR
        end
#        Logger.info "strip= #{pathname.inspect}, @@strip #{@@strip.inspect}"
      end
      def self.strip
        @@strip
      end
      # clean from leading dots or slashes
      def self.clean pathname
        loop do
#          Logger.info "clean #{pathname.inspect}"
          case pathname[0,1]
          when '.', ::File::SEPARATOR
            pathname = pathname[1..-1]
          else
            break
          end
        end
        pathname
      end
      # ensure pathname is stripped
      def initialize pathname
        if pathname.is_a? StrippedPath
          super pathname
        else         
          pathname = StrippedPath.clean(pathname).delete_prefix(@@strip)
          super pathname
        end
      end
    end

    #
    # Directory
    #
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
      @@collection = if database.collection_exists?(name: "Directories")
                       database.get_collection(name: "Directories")
                     else
                       database.create_collection(name: "Directories")
                     end
    end
    def self.cleanup
      @@database.delete_collection(name: "Directories") rescue nil
    end

    # path component to strip
    def self.strip= pathname
      StrippedPath.strip = pathname
    end
    def self.strip
      StrippedPath.strip
    end

    #
    # class level
    #

    #
    # create new Directory entry
    # @returns Directory
    #
    def self.create?(path)
#      Logger.info "Directory.create? #{path.inspect}"
      d = self.get(path)
      return d if d
      Directory.new(path).create!
    end
    #
    # read existing Directory by path
    # @return Directory if exist, nil else
    #
    def self.get(path)
      d = nil
      begin
        pathname = StrippedPath.new(path)
        document = @@collection.get_document(attributes: {pathname: pathname})
        d = Directory.new(document) if document
      rescue Arango::Error => e
      end
      d
    end

    #
    # read existing directory by id
    # @return Directory if exist, nil else
    #
    def self.get_by_id(id)
      d = nil
      begin
        document = @@collection.get_document(key: id)
        d = Directory.new(document)
      rescue Arango::Error => e
      end
      d
    end
    #
    # does directory exist
    # @returns Boolean
    #
    def self.exists?(path)
      pathname = StrippedPath.new(path)
      !!@@collection.get_document(attributes: {pathname: pathname})
    end

    #
    # read existing directory by id
    # @return Directory if exist, nil else
    #
    def self.get_by_id(id)
      d = nil
      if id
        begin
 #         Logger.info("Directory.get_by_id #{id.inspect}")
          document = @@collection.get_document(key: id)
          d = Directory.new(document)
        rescue Arango::Error => e
        end
      end
      d
    end

    #
    # @returns number of entries in collection
    #
    def self.count
      @@collection.count rescue nil
    end

    public
    #
    # instance level
    #
    attr_reader :id, :pathname
    def initialize arg
#      Logger.info "Directory#new #{arg.inspect}"
      case arg
      when Arango::Document::Base
        @id = arg.key
        @pathname = arg.pathname
      when StrippedPath
        @pathname = arg
        @id = nil
      when String
        @pathname = StrippedPath.new(arg)
        @id = nil
      else
        raise "Expecting string name instead of #{arg.class}"
      end
    end

    def to_s
      "#{@id}:#{@pathname}"
    end
    def created?
      !@id.nil?
    end
    alias loaded? created?

    #
    # create new Directory in collection
    # use Directory.create? if you want create-if-not-exists semantics
    #
    # @returns Directory
    #
    def create!
#      Logger.info("Directory#create! #{self}")
      raise if @pathname.nil?
      attrs = { pathname: @pathname }
      document = @@collection.create_document(attributes: attrs)
      @id = document.key
#      Logger.info("Directory#create! #{attrs[:pathname].inspect} = #{@id}")
      self
    end
    #
    # delete instance in database
    #
    def delete
      @@collection.delete_document(attributes: {name: @name})
      @id = nil
    end
  end
end

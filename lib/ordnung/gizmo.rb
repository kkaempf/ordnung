require_relative 'name'
require 'pathname'

module Ordnung
  class Gizmo
    private
    #
    # Hash of extension:String => implementation:Class
    #   daisy chain            => extension:String
    @@extensions = Hash.new
    #
    # logger
    #
    def self.log
      Ordnung::logger
    end
    #
    # Find implementation class for extension ext
    # ext:String
    def self.find_implementation_for ext
      @@extensions[ext]
    end
    #
    # add klass implementing extensions
    def self.add_extensions klass, extensions=nil
      return unless extensions # skip abstract implementation (i.e. Container)
      extensions.each do |ext|
        existing_klass = self.find_implementation_for ext
        if existing_klass
          next if existing_klass == klass
          raise "#{klass} claims extension #{ext.inspect} already claimed by #{existing_klass}"
        end
        @@extensions[ext] = klass
      end
    end
    #
    # walk implementations and register their extensions
    def self.walk_gizmos dir, module_prefix
      deferred = []
      ::Dir.foreach(dir) do |x|
        path = ::File.join(dir, x)
        case x
        when ".", ".."
          next
        when /^(.*)\.rb$/
          klass = $1.capitalize
#          log.info "Gizmo #{path}(#{klass})"
          require path
          gizmo = eval "#{module_prefix}::#{klass}"
          extensions = gizmo.extensions
          add_extensions gizmo, extensions
          Ordnung::Db.collect_properties gizmo.properties rescue nil
        else
          if ::File.directory?(path)
            deferred << [path, "#{module_prefix}::#{x.capitalize}"]
          end
        end
      end
      deferred.each do |path, klass|
        walk_gizmos path, klass
      end
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # recursively import path
    #
    private
    def self.import_directory pathname, parent_id=nil
#      log.info "Gizmo.import_directory #{pathname}"
      directory = @@extensions['dir']
      gizmo = nil
      ::Dir.foreach(pathname) do |node|
        case node
        when ".", ".."
          next
        when "__MACOSX", ".DS_Store"    # Mac stuff
          next
        when ".Trash-1000"              # Trashcan
          next
        when ".directory", ".updated"   # Helper stuff
          next
        when ".git"                     # git
          next
        else
          path = ::File.join(pathname, node)
          gizmo = self.import path
        end
      end
      gizmo
    end
    def self.import_file pathname, parent_id=nil
      return nil if pathname.to_s[-1,1] == '~'     # skip backups
#      log.info "Gizmo.import file #{pathname}"
      dir, base = pathname.split
      # create parents
      parent_id = nil
      dir.to_s.split(::File::SEPARATOR).each do |node|
        next if node == ''
        gizmo = Gizmo.new(node, parent_id)
        gizmo.upsert
        Tag.new(node)
        parent_id = gizmo.id
      end
      elements = base.to_s.split('.')
      if elements.size == 1 # no extension
        klass = Gizmo.detect pathname
      else
        # find largest extension
        # for a.b.c.d
        #  try a - b.c.d, a.b - c.d, a.b.c - d
        name = elements.shift
        loop do
          break if elements.empty?
          extension = elements.join('.') # build extension from all remaining elements
          klass = @@extensions[extension]
#          log.info "\t#{extension} -> #{klass.inspect} ?"
          break if klass
          name << "."               # not found
          name << elements.shift    #  move one more element to name
        end
        if klass.nil?
          log.warn "Unimplemented #{base}(#{dir})"
          klass = Ordnung::Blob
        end
      end
      log.info "#{__callee__}: #{klass}.new(#{base.inspect}, #{parent_id})"
      gizmo = klass.new(base, parent_id)
      gizmo.upsert
      gizmo
    end
    public
    def self.import path, parent_id=nil
      pathname = Pathname.new ::File.expand_path(path)
      if pathname.directory?
        self.import_directory pathname, parent_id
      else
        self.import_file pathname, parent_id
      end
    end
    #
    # detect extensionless gizmo
    def self.detect pathname
      exec = "file -b #{pathname.to_s.inspect}"
      file = `#{exec}`
      klass = nil
      case file.chomp
      when "ASCII text", "Unicode text, UTF-8 text", "ASCII text, with no line terminators"
        klass = @@extensions['txt']
      when "Ruby script, ASCII text"
        klass = @@extensions['rb']
      else
        klass = Ordnung::Blob
      end
      klass
    end
    #
    # find Gizmo id by pattern
    # @return id
    #
    def self.find pattern
      case pattern
      when String
        id = Name.by_name pattern
      else
        nil
      end
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Database methods
    #
    def index
      Gizmo.index
    end
    #
    #
    # Convert instance variables to Hash
    #
    def to_hash
      hash = Hash.new
      instance_variables.each do |var|
        hash[var] = instance_variable_get var
      end
#      Gizmo.log.info "#{self}.to_hash #{hash.inspect}"
      hash
    end
    #
    # update or insert
    # @return id
    #
    def upsert
      hash = to_hash
      @id = Ordnung::Db.by_hash index, hash
#      Gizmo.log.info "upsert #{hash.inspect} -> #{@id}"
      return if @id
      hash[:@addedAt] = @addedAt = Time.now.floor
      hash[:class] = self.class
      @id = Ordnung::Db.create index, hash
    end
    #
    # Gizmo by id
    # @return gizmo
    #
    def self.by_id id
      raise "No id given" if id.nil?
      hash = Ordnung::Db.by_id(self.index, id)
#      log.info "Gizmo.by_id #{id} -> #{hash.inspect}"
      gizmo = nil
      if hash
#        log.info "Gizmo.by_id hash #{hash.inspect}"
        klass = hash['class']
        gizmo = (eval klass).new hash, id
      end
      gizmo
    end
    #
    # Database index name
    #
    def self.index
      @@index ||= "ordnung-gizmos"
    end
    # set index (for testing)
    def self.index= idx
      @@index = idx
    end
    #
    # Database type mapping
    #
    def self.properties
      {
        :class =>     { type: 'keyword' },
        :@nameId =>   { type: 'keyword' },
        :@parentId => { type: 'keyword' },
        :@addedAt =>  { type: 'date', format: 'yyyy-MM-dd HH:mm:ss Z' } # 2023-11-08 16:03:40 +0100
      }
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    attr_reader :nameId, :parentId, :addedAt
    #
    # load all Gizmo implementations
    def self.init
      Name.init
      Ordnung::Db.properties = self.properties
      self.walk_gizmos ::File.join(::File.dirname(__FILE__), "gizmos"), "Ordnung"
      Ordnung::Db.create_index self.index
    end
    #
    # Gizmo#new
    #
    def initialize name, parent_id=nil
#      Gizmo.log.info "Gizmo.new(#{name.class}:#{name})"
      case name
      when String, Pathname
#        Gizmo.log.info "Gizmo.new(#{parent_id} / #{name.inspect})"
        @nameId = Name.finsert(name)
        @parentId = parent_id
      when Hash
#        Gizmo.log.info "Gizmo.new(#{name.inspect}) -> #{parent_id}"
        @id = parent_id
        @parentId = name['@parentId']
        @nameId = name['@nameId']
        @addedAt = Time.new(name['@addedAt'])
      else
        raise "Can't create Gizmo from #{name.inspect}"
      end
#      Gizmo.log.info "\t ==> #{self}"
    end
    def to_s
      "Gizmo(#{self.name}->#{@parentId})"
    end
    def == gizmo
      self.class == gizmo.class &&
        @nameId == gizmo.nameId &&
        @parentId == gizmo.parentId &&
        @addedAt == gizmo.addedAt
    end
    def name
      raise "No name" if @nameId.nil?
      Name.by_id(@nameId)
    end
    def id
      @id
    end
    #
    # File helper method
    # (re-)create full path  /dir <-parent- dir <-parent- ...
    #
    def path
      if @parentId
        begin
          ppath = Gizmo.by_id(@parentId).path
          ::File.join(ppath, name)
        rescue
          Gizmo.log.info "*** Gizmo.path(#{ppath.inspect} / #{name.inspect})"
          raise
        end
      else
        "/#{name}"
      end
    end
    #
    # iterate over each duplicate
    # @return Iterator
    def each
    end
    #
    # iterate over each assigned tag
    # @return Iterator
    def each_tag
    end
    #
    # Gizmo#has? tag
    # @return Boolean
    def has? tag
      tag.to? @id
    end
    #
    # Gizmo#tag! tag
    # add tag to gizmo
    def tag tg
      tg.tag_gizmo @id
    end
    #
    # Gizmo#untag! tag
    # remove tag from gizmo
    def untag tag
      tag.untag_gizmo @id
    end
  end
end

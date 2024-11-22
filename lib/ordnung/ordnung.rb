require_relative "db"
require_relative "gizmo"
require_relative "tag"
require_relative "tagging"

module Ordnung
  #
  # Main instance providing an API to import, tag, and find files
  #
  class Ordnung
    #
    # Make toplevel +Logger+ accessible
    #
    def self.logger
      ::Ordnung::logger
    end
    #
    # Hash of extension:String => implementation:Class
    #   daisy chain            => extension:String
    #
    @@extensions = Hash.new
    #
    # Find implementation class for extension ext
    # ext:String
    #
    def find_implementation_for ext
      @@extensions[ext]
    end
    #
    # add klass implementing extensions
    #
    def add_extensions klass
      extensions = klass.extensions
      return unless extensions # skip abstract implementation (i.e. Container)
      extensions.each do |ext|
        existing_klass = find_implementation_for ext
        if existing_klass
          next if existing_klass == klass
          raise "#{klass} claims extension #{ext.inspect} already claimed by #{existing_klass}"
        end
        @@extensions[ext] = klass
      end
    end
    #
    # walk implementations and register their extensions
    #
    def walk_gizmos dir, module_prefix
      deferred = []
      #
      # walk over the implemetation files
      #
      ::Dir.foreach(dir) do |x|
        path = ::File.join(dir, x)
        case x
        when ".", ".."
          next
        when /^(.*)\.rb$/
          klass = $1.capitalize
          log.info "Found #{path} implementing #{klass}"
          require path
          gizmo = eval "#{module_prefix}::#{klass}"
          add_extensions gizmo
          Ordnung::Db.collect_properties gizmo.properties rescue nil
        else
          if ::File.directory?(path)
            deferred << [path, "#{module_prefix}::#{x.capitalize}"]
          else
            log.info "Skipping unknown implementation file #{path} (not .rb or directory)"
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
    def import_directory pathname, parent_id=nil
      log.info "Ordnung.import_directory #{pathname}"
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
          gizmo = import path
        end
      end
      gizmo
    end
    #
    # import a +File+ as +Gizmo+
    #
    def import_file pathname, parent_id=nil
      return nil if pathname.to_s[-1,1] == '~'     # skip backups
      log.info "Gizmo.import file #{pathname}"
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
          log.info "\textension >#{extension}< -> Class >#{klass.inspect}< ?"
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
    #
    # Import anything (file or directory)
    #
    def import path, parent_id=nil
      pathname = Pathname.new ::File.expand_path(path)
      if pathname.directory?
        import_directory pathname, parent_id
      else
        import_file pathname, parent_id
      end
    end
    #
    # detect extensionless gizmo
    #
    def detect pathname
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
    # make database instance accessible
    #
    attr_reader :db
    # create instance of Ordnung, initializing the infrastructure
    #
    def initialize
      @db = Db.new
      Name.db = @db
      Tag.db = @db
#      Tagging.db = @db
#      Gizmo.db = @db
      #
      # load all Gizmo implementations into the Ordnung namespace
      #
#      walk_gizmos ::File.join(::File.dirname(__FILE__), "gizmos"), "Ordnung"
    end

  end
end
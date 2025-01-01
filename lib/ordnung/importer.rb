require_relative "db"
require_relative "name"
require_relative "tag"
require_relative "gizmo"
require_relative "tagging"

module Ordnung
  class Importer
    #
    # Hash of extension:String => implementation:Class
    #   daisy chain            => extension:String
    #
    @@extensions = Hash.new
    #
    #
    #
    def log
      ::Ordnung.logger
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
#          log.info "Found #{path} implementing #{klass}"
          require path
          gizmo = eval "::#{module_prefix}::#{klass}"
          add_extensions gizmo
#          log.info "    collect_properties #{gizmo}: #{gizmo.properties.inspect}"
          @db.collect_properties gizmo.properties rescue nil
        when /^(.*)\.rb~$/
          # silently skip editor backups
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
        klass = ::Ordnung::Blob
      end
      klass
    end
    #
    # recursively import pathname as directory
    # called if pathname.directory? is true
    #
    # @return +Gizmo+
    #
    private
    def import_directory pathname, depth=0, parent_id=nil
      log.info "Importer.import_directory #{pathname.inspect}, #{depth.inspect}, #{parent_id.inspect}"
      dirname, basename = pathname.split
      log.info "\tdirname #{dirname.inspect}, basename #{basename.inspect}"
      if parent_id.nil?
        parents = []
        base = basename
        while dirname != base
          dir, base = dirname.split
          break if dir == base
          parents.unshift [base, dirname]
          dirname = dir
        end
        log.info "\tparents #{parents.inspect}"
        parents.each do |parent,dirname|
          dir = Containers::Directory.new(parent, parent_id, dirname)
          dir.upsert
          parent_id = dir.self_id
        end
      end
      directory = Containers::Directory.new(basename, parent_id, pathname)
      directory.upsert
      return directory if depth <= 0
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
        when "@eaDir", ".@__thumb"      # Synology/Qnap
          next
        else
          path = ::File.join(pathname, node)
          import path, depth-1, directory.self_id
        end
      end
      directory
    end
    #
    # import a +Pathname+ as +Gizmo+
    # called if pathname.directory? is false and the file's parent_id is known
    # name: filename (after last slash)
    # parent_id: Ordnung::Containers::Directory
    # pathname: full pathname to access/read file
    #
    # @return +Gizmo+
    #
    def import_file name, parent_id, pathname
      return nil if pathname.to_s[-1,1] == '~'     # skip backups
      unless ::File.readable?(pathname)
        log.error "File #{pathname.inspect} is not readable"
        return nil
      end
      log.info "Importer.import_file #{name.inspect}, #{parent_id.inspect}, #{pathname.inspect}"
      #
      # find largest matching extension
      #
      elements = name.to_s.split('.')
      if elements[0].empty? # dot-file
        return nil # skip dot files
      end
      if elements.size == 1 || # no extension
        klass = detect pathname
      else
        # find largest extension
        # for a.b.c.d
        #  try a - b.c.d, a.b - c.d, a.b.c - d
        elements.shift # drop name, we look after the dot
        loop do
          break if elements.empty?
          extension = elements.join('.') # build extension from all remaining elements
          klass = @@extensions[extension]
          log.info "\textension >#{extension}< -> Class >#{klass.inspect}< ?"
          break if klass # found matching extension !
          elements.shift # shorten remaining extension
        end
        if klass.nil?
          log.warn "Unimplemented #{name}(#{pathname})"
          klass = ::Ordnung::Blob
        end
      end
      log.info "Importer.import as #{klass}.new(#{name.inspect}, #{parent_id}, #{pathname.inspect})"
      gizmo = klass.new(name, parent_id, pathname)
      gizmo.upsert
      gizmo
    end
    #
    # - - - - - - - - - - - - - - - - - - - - - - - -
    #
    public
    #
    # Import anything (file or directory)
    #
    # path: filesystem path
    # depth: directory depth to import
    #        0: just directory as container placeholder
    #        1: just directory and its direct contents (subdirs only a depth 0)
    #       -1: recursive import
    #
    def import pathname, depth=0, parent_id=nil
      depth = depth.to_i rescue 0
      log.info "Importer.import #{pathname.inspect}, #{depth.inspect}, #{parent_id.inspect}"
      unless pathname.is_a? Pathname
        pathname = Pathname.new ::File.expand_path(pathname)
      end
      if pathname.directory?
        import_directory pathname, depth, parent_id
      else
        parent, base = pathname.split
        if parent_id.nil?
          dir = import_directory parent, 0
          log.info "\timported #{parent.inspect} to #{dir.inspect}"
          parent_id = dir.self_id
        end
        import_file base, parent_id, pathname
      end
    end
    #
    # initialize the infrastructure
    #
    def initialize db
      @db = db
      #
      # load all Gizmo implementations into the Ordnung namespace
      #
      walk_gizmos ::File.join(::File.dirname(__FILE__), "gizmos"), "Ordnung"
    end

  end
end

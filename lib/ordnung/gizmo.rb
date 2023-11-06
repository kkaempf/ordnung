require_relative 'name'
require 'pathname'
require 'date'

module Ordnung
  attr_reader :id, :nameId, :parent, :addedAt
  class Gizmo
    private
    #
    # Hash of extension:String => implementation:Class
    #   daisy chain            => extension:String
    @@extensions = Hash.new
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
          raise "#{klass} claims extension #{ext} already claimed by #{existing_klass}"
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
    public
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    def self.import path
      pathname = Pathname.new path
      if pathname.directory?
#        log.info "Gizmo.import directory #{pathname}"
        directory = @@extensions['dir']
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
          else
            pathname = ::File.join(path, node)
            self.import pathname
          end
        end
      else
        return if pathname.to_s[-1,1] == '~'
#        log.info "Gizmo.import file #{pathname}"
        dir, base = pathname.split
        # create parents
        dir.to_s.split(::File::SEPARATOR).each do |node|
          parent = Gizmo.new node, parent
        end
        elements = base.to_s.split('.')
        if elements.size == 1 # no extension
          klass = Gizmo.detect pathname
        else
          # find largest extension
          name = elements.shift
          loop do
            break if elements.empty?
            extension = elements.join('.') # build extension from all remaining elements
            klass = @@extensions[extension]
#            log.info "\t#{extension} -> #{klass.inspect} ?"
            break if klass
            name << "."               # not found
            name << elements.shift    #  move one more element to name
          end
        end
        raise "Unimplemented #{base}(#{dir})" unless klass
      end
    end
    #
    # find Gizmo by pattern
    def self.find pattern
      case pattern
      when String
        id = Name.find pattern
      else
        nil
      end
    end
    #
    # detect extensionless gizmo
    def self.detect pathname
      exec = "file -b #{pathname.to_s.inspect}"
      file = `#{exec}`
      case file.chomp
      when "ASCII text", "Unicode text, UTF-8 text", "ASCII text, with no line terminators"
        @@extensions['txt']
      else
        log.info "Gizmo.detect #{pathname}:#{exec.inspect}"
      end
    end
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # initialze all Gizmo implementations
    def self.init
      self.walk_gizmos File.join(File.dirname(__FILE__), "gizmos"), "Ordnung"
    end
    #
    # Gizmo#new
    #
    def initialize name, parent=nil
      @nameId = Name.create(name)
      @parent = parent
      @addedAt = DateTime.now
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
      false
    end
  end
end

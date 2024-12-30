require_relative "db"
require_relative "name"
require_relative "tag"
require_relative "gizmo"
require_relative "tagging"
require_relative "importer"

module Ordnung
  #
  # Main instance providing an API to import, tag, and find files
  #
  class Ordnung
    #
    # - - - - - - - - - - - - - - - - - - - - - - - -
    #
    public
    def log
      ::Ordnung.logger
    end
    #
    # Import anything (file or directory)
    #
    # path: filesystem path
    # depth: directory depth to import
    #        0: just directory as container placeholder
    #        1: just directory and its direct contents (subdirs only a depth 0)
    #       -1: recursive import
    #
    def import path, depth=0
      @importer.import path, depth
    end
    #
    # make database and logger instance accessible
    #
    attr_reader :db, :log
    #
    # create instance of Ordnung, initializing the infrastructure
    #
    def initialize
      @log = ::Ordnung.logger
      @db = Db.new @log
      Name.db = @db
      Tag.db = @db
      Tagging.db = @db
      Gizmo.db = @db

      @importer = Importer.new @db
    end

  end
end

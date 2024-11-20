module Ordnung
  # container namespace for Blob
  module Blobs
    #
    # SQLite database
    #
    class Sqlitedb < File
      # extensions associated with +sqlite+ files
      def self.extensions
        ["sqlitedb", "sqlitedb-shm","sqlitedb-wal"]
      end
      # properties of +sqlite+ file (beyond what +Blob+ already provides)
      def self.properties
        nil
      end
    end
  end
end

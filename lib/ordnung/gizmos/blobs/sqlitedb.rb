#
# SQLite database
#
module Ordnung
  module Blobs
    class Sqlitedb < File
      def self.extensions
        ["sqlitedb", "sqlitedb-shm","sqlitedb-wal"]
      end
    end
  end
end

#
# log files
#
module Ordnung
  module Text
    class Log < File
      def self.extensions
        ["log", "log.1", "log.2", "log.3"]
      end
      def self.properties
        nil
      end
    end
  end
end

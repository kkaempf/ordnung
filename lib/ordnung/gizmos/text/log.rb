module Ordnung
  # namespace for text files
  module Text
    #
    # log files
    #
    class Log < File
      # list of extensions associated with +log+ files
      def self.extensions
        ["log", "log.1", "log.2", "log.3"]
      end
      # properties of +log+ files (beyond what +File+ already provides)
      def self.properties
        nil
      end
    end
  end
end

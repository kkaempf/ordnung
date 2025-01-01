require_relative 'file'

module Ordnung
  #
  # Representing a binary large object
  # just a stream of bytes without associated type
  #
  # Acts as an abstract base class for the actual file types
  #
  class Blob < ::Ordnung::File
    def log
      ::Ordnung.logger
    end
    #
    # @return list of extensions associated to this type
    #
    def self.extensions
      nil # abstract
    end
    #
    # properties of file
    #
    def self.properties
      nil
    end
  end
end

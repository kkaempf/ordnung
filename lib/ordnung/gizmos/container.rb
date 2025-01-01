require_relative 'file'

module Ordnung
  #
  # A +Container+ doesn't provide any actual content
  # but provides a collection of Files
  #
  # Used to represent directories and archives (tar, zip, ...)
  #
  class Container < ::Ordnung::File
    #
    # is not associated with any extensions
    # @return nil
    #
    def self.extensions
      nil # abstract
    end
    #
    # doesn't have any properties
    # @return nil
    #
    def self.properties
      nil
    end
  end
end

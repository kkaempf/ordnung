unless defined?(ORDNUNG_TOPLEVEL)
  #
  # toplevel directory for this gem
  #
  ORDNUNG_TOPLEVEL = File.expand_path("..", File.dirname(__FILE__))
end

require 'logger'

module Ordnung
  @@logger = Logger.new($stderr)
  #
  # make toplevel Logger accessible
  #
  def self.logger
    @@logger
  end
end

require_relative "ordnung/importer"

require 'yaml'

unless defined?(ORDNUNG_TOPLEVEL)
  #
  # toplevel directory for this gem
  #
  ORDNUNG_TOPLEVEL = File.expand_path("..", File.dirname(__FILE__))
end

require_relative "ordnung/logger"
require_relative "ordnung/version"

STDERR.puts __FILE__

#
# Ordnung is the namespace for the backend
#

module Ordnung
  #
  # Ordnung.logger object access
  #
  def self.logger
    @@logger ||= Logger.new
  end
  #
  # Ordnung.import +path+
  #
  def self.import path
    Gizmo.import path
  end
end

require_relative "ordnung/db"
require_relative "ordnung/gizmo"
require_relative "ordnung/tag"
require_relative "ordnung/tagging"

module Ordnung
  # startup sequence
  Db.init
  Gizmo.init
  Tag.init
end

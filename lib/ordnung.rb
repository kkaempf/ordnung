require 'yaml'

unless defined?(ORDNUNG_TOPLEVEL)
  ORDNUNG_TOPLEVEL = File.expand_path("..", File.dirname(__FILE__))
end

require_relative "ordnung/logger"
require_relative "ordnung/version"

module Ordnung
  def self.logger
    @@logger ||= Logger.new
  end
  def self.import path
    Gizmo.import path
  end
end

require_relative "ordnung/db"
require_relative "ordnung/gizmo"
require_relative "ordnung/tag"

module Ordnung
  Db.init
  Gizmo.init
  Tag.init
end

require 'yaml'

unless defined?(ORDNUNG_TOPLEVEL)
  ORDNUNG_TOPLEVEL = File.expand_path("..", File.dirname(__FILE__))
end

require_relative "ordnung/gizmo"
require_relative "ordnung/logger"
require_relative "ordnung/tag"
require_relative "ordnung/version"

module Ordnung

  extend self

  def logger
    @@logger ||= Logger.new
  end
  
  class Ordnung
    def logger
      ::Ordnung.logger
    end
  end

end

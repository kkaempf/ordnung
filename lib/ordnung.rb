require 'yaml'

unless defined?(ORDNUNG_TOPLEVEL)
  ORDNUNG_TOPLEVEL = File.expand_path("..", File.dirname(__FILE__))
end

require_relative "ordnung/directory"
require_relative "ordnung/mime_type"
require_relative "ordnung/file"
require_relative "ordnung/logger"
require_relative "ordnung/tag"
require_relative "ordnung/version"

module Ordnung

  extend self

  def database= database
    Directory.database = database
    MimeType.database = database
    File.database = database
    Tag.database = database
    Edge.database = database
  end
  def setup
    Directory.setup
    MimeType.setup
    File.setup
    Tag.setup
    Edge.setup
  end
  def cleanup
    Edge.cleanup
    Tag.cleanup
    File.cleanup
    MimeType.cleanup
    Directory.cleanup
  end

  def logger
    @@logger ||= Logger.new
  end

  def mimetype
    @@mimetype ||= MimeType.new
  end
  
  class Ordnung
    def logger
      ::Ordnung.logger
    end
  end

end

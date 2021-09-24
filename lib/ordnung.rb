require 'yaml'

unless defined?(TOPLEVEL)
  TOPLEVEL = File.expand_path("..", File.dirname(__FILE__))
end

require_relative "ordnung/directory"
require_relative "ordnung/mime_type"
require_relative "ordnung/file"
require_relative "ordnung/logger"
require_relative "ordnung/version"

module Ordnung

  extend self

  def database= database
    Directory.database = database
    MimeType.database = database
    File.database = database
  end
  def setup
    File.setup
    MimeType.setup
    Directory.setup
  end
  def cleanup
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

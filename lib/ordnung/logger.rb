#
# Ordnung::Logger
#
require 'logger'

module Ordnung

  #
  # Generic logger implementation
  #
  class Logger < ::Logger
    #
    # +logname+ can be `stdout`, `stderr`, or a valid file name
    # +logfile+ is the actual `::File` object to log to
    #
    attr_reader :logname, :logfile
    #
    # log an error with an attached +msg+
    #
    def self.error msg
      ::Ordnung.logger.error msg
    end
    #
    # log a warning with an attached +msg+
    #
    def self.warn msg
      ::Ordnung.logger.warn msg
    end
    #
    # log an information with an attached +msg+
    #
    def self.info msg
      ::Ordnung.logger.info msg
    end
    #
    # log a debug with an attached +msg+
    #
    def self.debug msg
      ::Ordnung.logger.debug msg
    end
    #
    # start the logger (to stdout, stderr, or a log file)
    #
    def initialize
      @logname = "stderr"
      @logfile = nil
      case @logname
      when "stderr", "STDERR"
        @logfile = STDERR
      when "stdout", "STDOUT"
        @logfile = STDOUT
      when "", nil
        logdir = File.join(ORDNUNG_TOPLEVEL,"log")
        Dir.mkdir(logdir) rescue nil
        @logname = File.join(logdir, "ordnung.log")
      else
        # assume valid file path
      end
      if @logfile.nil?
        begin
          @logfile = File.new(@logname, "a+")
        rescue Exception => e
          STDERR.puts "Log file creation '#{@logname}' failed: #{e}"
        end
      end
      super @logfile
      self.level = case "debug"
        when "debug" then Logger::DEBUG
        when "info" then Logger::INFO
        when "warn" then Logger::WARN
        when "error" then Logger::ERROR
        else
          Logger::FATAL
        end
    end
  end

end

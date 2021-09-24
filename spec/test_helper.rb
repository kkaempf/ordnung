DEBUG = false unless defined?(DEBUG)
TOPLEVEL = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$:.push(File.join(TOPLEVEL, 'lib'))

require 'ordnung'
require 'rspec'
require 'simplecov'
SimpleCov.start
require 'arango-driver'

module Helpers
  def connect
    Arango.connect_to_server username: "root", password: "", host: "localhost", port: "8529"
  end
  def directory
    File.join(TOPLEVEL, 'spec')
  end
  def data_directory
    File.join(TOPLEVEL, 'spec', 'data')
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.color = true
  config.before :all do
  end

  config.after(:all) do
  end
end

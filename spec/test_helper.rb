DEBUG = false unless defined?(DEBUG)
TOPLEVEL = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$:.push(File.join(TOPLEVEL, 'lib'))

require 'ordnung'

module Ordnung
  Name.index = "testing-names"
  Tag.index = "testing-tags"
  Gizmo.index = "testing-gizmos"
  Tagging.index = "testing-taggings"
end
require 'rspec'
require 'simplecov'
SimpleCov.start

module Helpers
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
    @ordnung = Ordnung::Ordnung.new
  end

  config.after(:all) do
#    @ordnung.db.delete_index(Ordnung::Name.index)
  end
end

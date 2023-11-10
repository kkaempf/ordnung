DEBUG = false unless defined?(DEBUG)
TOPLEVEL = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$:.push(File.join(TOPLEVEL, 'lib'))

module Ordnung
  class Name
    @@index = "testing-names"
  end
  class Gizmo
    @@index = "testing-gizmos"
  end
  class Tag < Gizmo
    @@index = "testing-tags"
  end
  class Tagging
    @@index = "testing-taggings"
  end
end
require 'ordnung'
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
    Ordnung::Db.init
  end

  config.after(:all) do
  end
end

# test files api
require_relative "test_helper"

describe Ordnung::MimeType do
  before :all do
    @server = connect
    @database = @server.create_database(name: "Testing")
    Ordnung.database = @database
  end

  before :each do
    Ordnung.setup
  end

  after :each do
    Ordnung.cleanup
  end

  after :all do
    @server.delete_database(name: "Testing")
  end


  context "mimetype management" do
    it "has name and id" do
      mt = Ordnung::MimeType.create("text/plain", [])
      expect(mt.mimetype).to be == 'text/plain'
      expect(mt.id.class).to be String
    end
    it "is case insensitive" do
      down = Ordnung::MimeType.create("text/plain", [])
      up = Ordnung::MimeType.new("text/plain".capitalize, [])
      expect(up.id).to be == down.id
    end
  end
end

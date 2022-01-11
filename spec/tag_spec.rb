# test files api
require_relative "test_helper"

describe Ordnung::Tag do
  before :all do
    @server = connect
    begin
      @server.delete_database(name: "Testing")
    rescue
    end
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

  context "tag creation" do
    it "can create a tag" do
      t = Ordnung::Tag.new("sample-tag").create!
      expect(t.id).to_not be_nil
    end
    it "can tag a file" do
    @file_one = File.join(data_directory, 'one')
      f = Ordnung::File.new(@file_one).create!
      t = Ordnung::Tag.new("sample-tag").create!
      expect(f.id).to_not be_nil
      expect(t.id).to_not be_nil
      f.tag(t)
    end
  end
end

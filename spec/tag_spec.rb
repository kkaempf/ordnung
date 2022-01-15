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
    it "can find a file by tag" do
      @file_one = File.join(data_directory, 'one')
      f = Ordnung::File.new(@file_one).create!
      t = Ordnung::Tag.new("sample-tag").create!
      f.tag(t)
      g = Ordnung::File.find_by_tag(t)
      expect(g.class).to eq Array
      found = g.first
      expect(found).to_not be_nil
      expect(found.id).to eq f.id
    end
    it "can find many files by tag" do
      @file_one = File.join(data_directory, 'one')
      @file_two = File.join(data_directory, 'two.txt')
      @file_three = File.join(data_directory, 'three.bytes')
      f1 = Ordnung::File.new(@file_one).create!
      f2 = Ordnung::File.new(@file_two).create!
      f3 = Ordnung::File.new(@file_three).create!
      t = Ordnung::Tag.new("sample-tag").create!
      f1.tag(t)
      f2.tag(t)
      f3.tag(t)
      g = Ordnung::File.find_by_tag(t)
      expect(g.class).to eq Array
      expect(g.size).to eq 3
      expect(g).to include(f1)
      expect(g).to include(f2)
      expect(g).to include(f3)
    end
  end
end

# test files api
require_relative "test_helper"

describe Ordnung::File do
  before :all do
    @server = connect
    @file_one = File.join(data_directory, 'one')
    @file_two = File.join(data_directory, 'two.txt')
    @file_three = File.join(data_directory, 'three.bytes')
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

  context "File directory stripping" do
    it "has a strip component ending with a slash" do
      Ordnung::File.strip = "/a/b/c"
      expect(Ordnung::File.strip).to eq '/a/b/c/'
      Ordnung::File.strip = "/a/"
      expect(Ordnung::File.strip).to eq '/a/'
    end
  end
  context "Ordnung::File class methods" do
    it "can create a new file entry" do
      f = Ordnung::File.new(@file_one)
      expect(f).to_not be_nil
    end
    it "keeps name, directory, and size" do
      f = Ordnung::File.new(@file_one)
      expect(f.name).to eq 'one'
      expect(f.mimetype).to_not be_nil
      expect(f.directory.pathname).to eq data_directory
      expect(f.size).to eq 1
      expect(f.checksum).to_not be_nil
    end
    it "keeps name, mimetype, size, and directory" do
      f = Ordnung::File.new(@file_two)
      expect(f.name).to eq ::File.basename(@file_two)
      expect(f.mimetype.mimetype).to eq 'text/plain'
      expect(f.mimetype.extensions).to include(::File.extname(@file_two)[1..-1])
      expect(f.directory.pathname).to eq data_directory
      expect(f.size).to eq 2
      expect(f.checksum).to eq "6b51d431df5d7f141cbececcf79edf3dd861c3b4069f0b11661a3eefacbba918"
    end
    it "returns nil on getting an unknown key" do
      g = Ordnung::File.get("xyzzy")
      expect(g).to be_nil
    end
    it "can be deleted via instance methods" do
      f = Ordnung::File.new(@file_one).create!
      expect(f.created?).to be true
      id = f.id
      g = Ordnung::File.get(id)
      expect(g).to_not be_nil
      f.delete
      expect(f.created?).to be false
      g = Ordnung::File.get(id)
      expect(g).to be_nil
    end
  end
  context "Ordnung::File instance methods" do
    it "can be stored" do
      f = Ordnung::File.new(@file_one)
      expect(f.id).to be_nil
      f.create!
      expect(f.id).to_not be_nil
    end
    it "can be retrieved with all attributes" do
      f = Ordnung::File.new(@file_one).create!
      expect(f.id).to_not be_nil
      g = Ordnung::File.get(f.id)
      expect(g).to_not be_nil
      expect(g.id).to eq(f.id)
      expect(g.name).to eq(f.name)
      expect(g.mimetype.mimetype).to eq(f.mimetype.mimetype)
      expect(g.directory.pathname).to eq(f.directory.pathname)
      expect(g.size).to eq(f.size)
      expect(g.checksum).to eq(f.checksum)
    end
  end
end

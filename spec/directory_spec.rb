# test files api
require_relative "test_helper"

describe Ordnung::File do
  before :all do
    @server = connect
    @file_one = File.join(data_directory, 'one')
    @file_two = File.join(data_directory, 'two.txt')
    @file_three = File.join(data_directory, 'three.bytes')
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

  context "Ordnung::Directory class methods" do
    it "doesn't duplicate identicals on create" do
      d = Ordnung::Directory.create?("a")
      e = Ordnung::Directory.create?("a")
      expect(d.id).to eq e.id
      expect(Ordnung::Directory.count).to eq 1
    end
    it "can count correctly" do
      d = Ordnung::Directory.create?("a")
      e = Ordnung::Directory.create?("b")
      expect(Ordnung::Directory.count).to eq 2
    end
    it "can get existing" do
      d = Ordnung::Directory.create?("a")
      e = Ordnung::Directory.get("a")
      expect(d.id).to eq e.id
    end
    it "can get non-existing" do
      d = Ordnung::Directory.get("a")
      expect(d).to be_nil
    end
    it "can check for existance" do
      d = Ordnung::Directory.create?("a")
      a_exists = Ordnung::Directory.exists?("a")
      b_exists = Ordnung::Directory.exists?("b")
      expect(a_exists).to be true
      expect(b_exists).to be false
    end
  end
  context "Ordnung::Directory instance methods" do
    it "can create a new directory entry" do
      d = Ordnung::Directory.new("a")
      expect(d).to_not be_nil
      expect(d.pathname).to eq "a"
    end
    it "can create a new path entry" do
      d = Ordnung::Directory.new("a/b")
      expect(d).to_not be_nil
      expect(d.pathname).to eq "a/b"
    end
    it "can create a long path entry" do
      d = Ordnung::Directory.new("a/b/c/d/e")
      expect(d).to_not be_nil
      expect(d.pathname).to eq "a/b/c/d/e"
    end
    it "can strip" do
      Ordnung::Directory.strip = "/a/b"
      d = Ordnung::Directory.new("/a/b/c/d/e")
      expect(d).to_not be_nil
      expect(d.pathname).to eq "c/d/e"
    end
  end
end

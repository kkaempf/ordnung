# test name api
require_relative "test_helper"

describe Ordnung::File do
  before :all do
    @name_one = "one"
  end

  before :all do
    Ordnung::Name.init
  end

  after :all do
    Ordnung::Db.delete_index(Ordnung::Name.index)
  end

  context "Ordnung::Name class methods" do
    it "can create a new name entry" do
      n = Ordnung::Name.finsert(@name_one)
      expect(n).to_not be_nil
    end
    it "can retrieve a name entry by id" do
      n = Ordnung::Name.finsert(@name_one)
      expect(n).to_not be_nil
      name = Ordnung::Name.by_id n
      expect(name).to eq(@name_one)
    end
    it "can retrieve a name entry by name" do
      n = Ordnung::Name.finsert(@name_one)
      expect(n).to_not be_nil
      g = Ordnung::Name.by_name @name_one
      expect(g).to eq(n)
    end
    it "returns nil on getting an unknown key" do
      g = Ordnung::Name.by_id("xyzzy")
      expect(g).to be_nil
    end
    it "prevents duplicates" do
      n = Ordnung::Name.finsert(@name_one)
      expect(n).to_not be_nil
      g = Ordnung::Name.finsert(@name_one)
      expect(g).to_not be_nil
      expect(n).to eq(g)
    end
  end
end

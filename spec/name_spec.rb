# test name api
require_relative "test_helper"

describe Ordnung::Name do
  before :all do
    @name_one = "one"
  end

  context "Ordnung::Name class methods" do
    it "can create a new name entry" do
      n = Ordnung::Name.new(@name_one)
      expect(n).to_not be_nil
      expect(n.self_id).to_not be_nil
      expect(n.name).to eq(@name_one)
    end
    it "can retrieve a name entry by id" do
      n = Ordnung::Name.new(@name_one)
      expect(n).to_not be_nil
      name = Ordnung::Name.by_id n.self_id
      expect(name).to_not be_nil
      expect(name.name).to eq(@name_one)
    end
    it "can retrieve a name entry by name" do
      n = Ordnung::Name.new(@name_one)
      expect(n).to_not be_nil
      id = Ordnung::Name.id_by_name @name_one
      expect(id).to eq(n.self_id)
    end
    it "returns nil on getting an unknown key" do
      id = Ordnung::Name.id_by_name("xyzzy")
      expect(id).to be_nil
    end
    it "prevents duplicates" do
      n = Ordnung::Name.new(@name_one)
      expect(n).to_not be_nil
      g = Ordnung::Name.new(@name_one)
      expect(g).to_not be_nil
      expect(n).to eq(g)
    end
  end
end

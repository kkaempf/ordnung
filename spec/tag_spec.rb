# test Tag api
require_relative "test_helper"

describe Ordnung::Tag do
  before :all do
    @file_one = ::File.join(data_directory, 'one')
    @file_two = ::File.join(data_directory, 'two.txt')
    @file_three = ::File.join(data_directory, 'three.bytes')
    Ordnung::Tag.init
  end

  after :all do
    Ordnung::Db.delete_index(Ordnung::Tag.index)
    Ordnung::Db.delete_index(Ordnung::Name.index)
  end

  context "tag creation" do
    it "can create a simple tag" do
      t = Ordnung::Tag.new("sample-tag")
      expect(t).to_not be_nil
      expect(t.id).to_not be_nil
      expect(t.name).to eq("sample-tag")
    end
    it "can create a complex tag" do
      t = Ordnung::Tag.new("file:visual:jpeg")
      expect(t).to_not be_nil
      expect(t.id).to_not be_nil
      expect(t.name).to eq("file:visual:jpeg")
    end
  end
end

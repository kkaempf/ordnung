# test Tag api
require_relative "test_helper"

describe Ordnung::Tag do

  context "tag creation" do
    it "can create a simple tag" do
      t = Ordnung::Tag.new("sample-tag")
      expect(t).to_not be_nil
      expect(t.self_id).to_not be_nil
      expect(t.name.name).to eq("sample-tag")
      expect(t.fullname).to eq("sample-tag")
    end
    it "can create a long tag" do
      t = Ordnung::Tag.new("long:tag")
      expect(t).to_not be_nil
      expect(t.self_id).to_not be_nil
      expect(t.fullname).to eq("long:tag")
    end
    it "can create a complex tag" do
      t = Ordnung::Tag.new("file:visual:jpeg")
      expect(t).to_not be_nil
      expect(t.self_id).to_not be_nil
      expect(t.fullname).to eq("file:visual:jpeg")
    end
    it "can create a more complex tag" do
      t = Ordnung::Tag.new("file:visual:jpeg:4")
      expect(t).to_not be_nil
      expect(t.self_id).to_not be_nil
      expect(t.fullname).to eq("file:visual:jpeg:4")
    end
  end
end

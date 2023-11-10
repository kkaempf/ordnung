# test Tagging api
require_relative "test_helper"

describe Ordnung::Tag do
  before :all do
    @file_one = ::File.join(data_directory, 'one')
    @file_two = ::File.join(data_directory, 'two.txt')
    @file_three = ::File.join(data_directory, 'three.bytes')
    @tag_one = Ordnung::Tag.new("tag-one")
    @tag_two = Ordnung::Tag.new("tag:two")
    Ordnung::Tagging.init
  end

  after :all do
    Ordnung::Db.delete_index(Ordnung::Tagging.index)
    Ordnung::Db.delete_index(Ordnung::Tag.index)
    Ordnung::Db.delete_index(Ordnung::Name.index)
  end

  context "tagging creation" do
    it "can create a simple tagging" do
      gizmo = Ordnung::Gizmo.import @file_one
      tagging = Ordnung::Tagging.new(@tag_one, gizmo)
      expect(tagging.gizmo_id).to eq(gizmo.id)
      expect(tagging.gizmo).to eq(gizmo)
      expect(tagging.tag_id).to eq(@tag_one.id)
      expect(tagging.tag).to eq(@tag_one)
    end
#    it "can create a complex tagging" do
#      gizmo = Ordnung::Gizmo.import @file_two
#      tagging = Ordnung::Tagging.new(@tag_two, gizmo)
#      expect(tagging.gizmo_id).to eq(gizmo.id)
#      expect(tagging.tag_id).to eq(@tag_two.id)
#    end
#    it "can retrieve a complex tagging" do
#      gizmo = Ordnung::Gizmo.import @file_two
#      found_tag = false
#      gizmo.each_tag do |tag|
#        if tag == @tag_one
#          found_tag = true
#          break
#        end
#      end
#      expect(found_tag).to eq(true)
#    end
  end
end

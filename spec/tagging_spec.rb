# test Tagging api
require_relative "test_helper"

describe Ordnung::Tag do
  before :all do
    @file_one = ::File.join(data_directory, 'one')
    @file_two = ::File.join(data_directory, 'two.txt')
    @file_three = ::File.join(data_directory, 'three.bytes')
    @tag_one = Ordnung::Tag.new("tag-one")
    @tag_two = Ordnung::Tag.new("tag:two")
  end

  after :all do
    @ordnung.db.delete_index(Ordnung::Gizmo.index)
    @ordnung.db.delete_index(Ordnung::Tagging.index)
    @ordnung.db.delete_index(Ordnung::Tag.index)
    @ordnung.db.delete_index(Ordnung::Name.index)
  end

  context "tagging creation" do
    it "can create a simple tagging" do
      gizmo = @ordnung.import @file_one
      expect(gizmo.class).to eq(Ordnung::Blob)
      gizmo.upsert
      tagging = Ordnung::Tagging.new(@tag_one, gizmo)
      expect(tagging.gizmo_id).to eq(gizmo.self_id)
      tg = tagging.gizmo
      expect(tg).to eq(gizmo)
      expect(tagging.tag_id).to eq(@tag_one.self_id)
      expect(tagging.tag).to eq(@tag_one)
    end
#    it "can create a complex tagging" do
#      gizmo = Ordnung::Gizmo.import @file_two
#      tagging = Ordnung::Tagging.new(@tag_two, gizmo)
#      expect(tagging.gizmo_id).to eq(gizmo.self_id)
#      expect(tagging.tag_id).to eq(@tag_two.self_id)
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

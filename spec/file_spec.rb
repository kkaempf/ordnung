# test File api
require_relative "test_helper"

describe Ordnung::Tag do
  before :all do
    @file_one = ::File.join(data_directory, 'one')
    @file_two = ::File.join(data_directory, 'two.txt')
    @file_three = ::File.join(data_directory, 'three.bytes')
  end

  after :all do
    @ordnung.db.delete_index(Ordnung::Gizmo.index)
    @ordnung.db.delete_index(Ordnung::Tagging.index)
    @ordnung.db.delete_index(Ordnung::Tag.index)
    @ordnung.db.delete_index(Ordnung::Name.index)
  end

  context "File creation" do
    it "can create Files" do
      gizmo1 = @ordnung.import @file_one
      gizmo2 = @ordnung.import @file_two
      gizmo3 = @ordnung.import @file_three
      count = 0
      Ordnung::File.each do |file|
        puts file.path
        count += 1
      end
      expect(count).to eq(3)
    end
  end
end

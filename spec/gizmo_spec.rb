# test Gizmo api
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

  context "Gizmo creation" do
    Ordnung::logger.info "\n---- gizmo_spec ----\n"
    it "can create a simple Gizmo" do
      gizmo1 = @ordnung.import @file_one
      gizmo2 = @ordnung.import @file_two
      gizmo3 = @ordnung.import @file_three
      count = 0
      @ordnung.each do |gizmo|
        STDERR.flush
        puts
        puts gizmo.path
        puts
        STDOUT.flush
      end
      expect(count).to eq(3)
    end
  end
end

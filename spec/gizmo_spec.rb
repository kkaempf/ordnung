# test Gizmo api
require_relative "test_helper"

describe Ordnung::Tag do
  before :all do
    @file_one = ::File.join(data_directory, 'one')
    @file_two = ::File.join(data_directory, 'two.txt')
    @file_three = ::File.join(data_directory, 'three.bytes')
  end

  context "Gizmo creation" do
    it "can create a simple Gizmo" do
      gizmo1 = @ordnung.import @file_one
      gizmo2 = @ordnung.import @file_two
      gizmo3 = @ordnung.import @file_three
      count = 0
      @ordnung.each(klass: Ordnung::Blob) do |gizmo|
        puts gizmo.path
        count += 1
      end
      expect(count).to eq(3)
    end
  end
end

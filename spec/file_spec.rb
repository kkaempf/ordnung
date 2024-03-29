# test files api
require_relative "test_helper"

describe Ordnung::File do
  before :all do
    @file_one = ::File.join(data_directory, 'one')
    @file_two = ::File.join(data_directory, 'two.txt')
    @file_three = ::File.join(data_directory, 'three.bytes')
    Ordnung::Gizmo.init
  end

  after :all do
    Ordnung::Db.delete_index(Ordnung::Gizmo.index)
    Ordnung::Db.delete_index(Ordnung::Name.index)
  end

  context "Ordnung::File class methods" do
    it "can create a new file entry" do
      f = Ordnung::File.new(@file_one)
      expect(f).to_not be_nil
    end
  end
  context "Ordnung::File instance methods" do
  end
end

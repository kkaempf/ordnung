# test files api
require_relative "test_helper"

describe Ordnung::Gizmo do
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

  context "Ordnung::Gizmo class methods" do
    it "can import a file" do
      Ordnung::Gizmo.import @file_one
    end
    it "can import a directory" do
      Ordnung::Gizmo.import data_directory
    end
  end
  context "Ordnung::File instance methods" do
  end
end

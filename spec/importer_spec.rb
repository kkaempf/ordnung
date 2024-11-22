# test files api
require_relative "test_helper"

describe Ordnung::Importer do
  before :all do
    @file_one = ::File.join(data_directory, 'one')
    @file_two = ::File.join(data_directory, 'two.txt')
    @file_three = ::File.join(data_directory, 'three.bytes')
  end

  context "Ordnung::Importer class methods" do
    it "can import a file" do
      @importer.import @file_one
    end
    it "can import a directory" do
      @importer.import data_directory
    end
  end
end

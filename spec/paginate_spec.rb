# test files api
require_relative "test_helper"

describe Ordnung::File do
  before :all do
    @server = connect
    @file_one = File.join(data_directory, 'one')
    begin
      @server.delete_database(name: "Testing")
    rescue
    end
    @database = @server.create_database(name: "Testing")
    Ordnung.database = @database
  end

  before :each do
    Ordnung.setup
  end

  after :each do
    Ordnung.cleanup
  end

  after :all do
    @server.delete_database(name: "Testing")
  end

  context "File pagination" do
    it "can paginate" do
      (1..10).each do
        f = Ordnung::File.new(@file_one).create!
        expect(f.id).to_not be_nil
      end
      expect(Ordnung::File.count).to eq(10)
      (0..4).each do |n|
        files = Ordnung::File.list(offset: (n*2), limit: 2)
        expect(files.size).to eq(2)
      end
    end
  end
end

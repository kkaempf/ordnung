# test files api
require_relative "test_helper"

describe Ordnung::Ordnung do

  context "Ordnung::Ordnung class methods" do
    it "exists" do
      @ordnung
    end
    it "has a database" do
      @ordnung.db
    end
    it "can log" do
      @ordnung.log.info "Hello, world !"
    end
  end
end

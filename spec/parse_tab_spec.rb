require 'phagefinder'

describe Phagefinder::Tab do
  it "should parse the tab file to GFF" do
    Phagefinder::Tab.should respond_to(:toGFF)
  end


end
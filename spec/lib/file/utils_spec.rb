require 'phagefinder/file/utils'

describe Phagefinder::File::Utils do
  
  before :each do 
    @ptt_file = Dir.pwd + "/spec/files/ptt_example.txt"
  end
  
  it "should take a pair of coordinates and always return start <= end" do
    utils = Phagefinder::File::Utils.new(@ptt_file)
    values = utils.orient_coordinates(456, 123)
    values.first.should == 123
    values.last.should == 456
    
    values = utils.orient_coordinates(21, 123)
    values.first.should == 21
    values.last.should == 123
    
    values = utils.orient_coordinates(961043, 1041426)
    values.first.should == 961043
    values.last.should == 1041426
    
  end

end
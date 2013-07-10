require 'phagefinder/file/utils'

describe Phagefinder::File::Utils do
  
  context "normal files" do
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

    it "should raise an error if there is no file" do
      expect { Phagefinder::File::Utils.new("/fake/file.txt")}.to raise_error
    end

    it "should capture the file headers where available" do
      @tab_file = Dir.pwd + "/spec/files/example_tab.txt"
      utils = Phagefinder::File::Utils.new(@tab_file)
      utils.parse_file(:remove_headers => true)
      utils.headers.size.should == 25
    end
  end
  
  
  context "blank files" do
    
    before :each do 
      @empty_file = Dir.pwd + "/spec/files/example_blank_tRNAscan.out"
    end
    
    it "should return an empty gff array" do
      utils = Phagefinder::File::Utils.new(@empty_file)
      expect { utils.parse_file(:remove_headers => true) }.to_not raise_error
    end
  end

end
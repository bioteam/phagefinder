require 'phagefinder/file/tab'

describe Phagefinder::File::Tab do
  
  before :each do 
    @tab_file = Dir.pwd + "/spec/files/tab_example.txt"
  end
  
  it "should throw an error if it is initialized without a file" do
   expect { pf = Phagefinder::File::Tab.new() }.to raise_error
  end
  
  it "should be initialized with a .tab file" do
    expect { pf = Phagefinder::File::Tab.new(@tab_file) }.to_not raise_error
    # pf.should respond_to(:toGFF)
  end
  
  it "should parse the file to GFF" do
    tab_file = Dir.pwd + "/spec/files/tab_example.txt"
    pf = Phagefinder::File::Tab.new(tab_file)
    
    expected_GFF = "minirun\tPhageFinder\tphage_sequence\t961043\t1041426\t0\t+\t0\tName=Large prophage"
    gff = pf.toGFF
    gff.size.should == 8
    gff.first.should == expected_GFF
  end

  

end
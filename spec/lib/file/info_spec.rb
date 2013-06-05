require 'phagefinder/file/info'

describe Phagefinder::File::Info do
  
  before :each do 
    @info_file = Dir.pwd + "/spec/files/info_example.txt"
  end
  
  it "should throw an error if it is initialized without a file" do
   expect { pf = Phagefinder::File::Info.new() }.to raise_error
  end
  
  it "should be initialized with a .info file" do
    expect { pf = Phagefinder::File::Info.new(@info_file) }.to_not raise_error
  end
  
  it "should parse the file to GFF" do
    pf = Phagefinder::File::Info.new(@info_file)
    
    expected_GFF = "minirun\tPhageFinder\tCDS\t190\t255\t0\t+\t0\tName=thr operon leader peptide;ID=NP_459006.1"
    gff = pf.toGFF
    gff.size.should == 12 # number of lines in the file
    gff.first.should == expected_GFF
    
    # minirun	1050000	NP_459016.1	11245	10841	hypothetical protein; -
    # test that it gets the strand correct based on orientation of start/end
    expected_last_GFF = "minirun\tPhageFinder\tCDS\t11245\t10841\t0\t-\t0\tName=hypothetical protein;ID=NP_459016.1"
    gff.last.should == expected_last_GFF
  end
  
  it "should have an empty method" do
    
  end
end
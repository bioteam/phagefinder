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
  end
  
end
require 'phagefinder/file/ptt'

describe Phagefinder::File::Ptt do
  
  before :each do 
    @ptt_file = Dir.pwd + "/spec/files/ptt_example.txt"
  end
  
  it "should throw an error if it is initialized without a file" do
   expect { pf = Phagefinder::File::Ptt.new() }.to raise_error
  end
  
  it "should be initialized with a .tab file" do
    expect { pf = Phagefinder::File::Ptt.new(@ptt_file) }.to_not raise_error
    # pf.should respond_to(:toGFF)
  end
  
  it "should parse a start..stop range field" do
    pf = Phagefinder::File::Ptt.new(@ptt_file)
    range = "123..456"
    pf.parse_range(range).should == ["123", "456"]
  end
  
  it "should parse the file name to get the main contig name" do
    pf = Phagefinder::File::Ptt.new(@ptt_file)
    pf.filename.should == "ptt_example"
  end
  
  it "should parse the file to GFF" do
    pf = Phagefinder::File::Ptt.new(@ptt_file)
    expected_GFF = "ptt_example\tPhageFinder\tCDS\t190\t255\t0\t+\t0\tName=thr operon leader peptide;ID=NP_459006.1"
    gff = pf.toGFF
    gff.first.should == expected_GFF
    
    
    last_expected_GFF = "ptt_example\tPhageFinder\tCDS\t9376\t9942\t0\t-\t0\tName=hypothetical protein;ID=NP_459014.1"
    gff.last.should == last_expected_GFF
  end

  it "should get all the rows" do
    pf = Phagefinder::File::Ptt.new(@ptt_file)
    pf.toGFF.size.should == 9 # Number of rows in the file
  end

end
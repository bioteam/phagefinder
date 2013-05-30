require 'phagefinder/file/trnascan'

describe Phagefinder::File::Trnascan do
  
  before :each do 
    @trnascan_file = Dir.pwd + "/spec/files/trnascan_example.txt"
  end
  
  it "should throw an error if it is initialized without a file" do
   expect { pf = Phagefinder::File::Trnascan.new() }.to raise_error
  end
  
  it "should be initialized with a .tab file" do
    expect { pf = Phagefinder::File::Trnascan.new(@trnascan_file) }.to_not raise_error
    # pf.should respond_to(:toGFF)
  end
  
  it "should parse the file to GFF" do
    pf = Phagefinder::File::Trnascan.new(@trnascan_file)
    expected_GFF = "NC_003197\ttRNAscan\ttRNA_gene\t290790\t290866\t88.37\t+\t0\tName=Ile GAT"
    gff = pf.toGFF
    gff.first.should == expected_GFF
    
    # NC_003197 	12	819399 	819474 	Lys	TTT	0	0	99.54
    last_expected_GFF = expected_GFF = "NC_003197\ttRNAscan\ttRNA_gene\t819399\t819474\t99.54\t+\t0\tName=Lys TTT"
    gff.last.should == last_expected_GFF
  end
 
  it "should get all the rows" do
    pf = Phagefinder::File::Trnascan.new(@trnascan_file)
    pf.toGFF.size.should == 12 # Number of rows in the file
  end

end
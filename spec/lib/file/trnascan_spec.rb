require 'phagefinder/file/trnascan'

describe Phagefinder::File::Trnascan do

  context "normal files" do
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
  
    it "should get the strand from the orientation of the begin/end values" do
      pf = Phagefinder::File::Trnascan.new(@trnascan_file)
      pf.get_strand(123,456).should eq "+"
      pf.get_strand(567,456).should eq "-"
    end
  
    it "should parse the file to GFF" do
      pf = Phagefinder::File::Trnascan.new(@trnascan_file)
      expected_GFF = "NC_003197\ttRNAscan\ttRNA_gene\t290790\t290866\t88.37\t+\t0\tName=Ile GAT"
      gff = pf.toGFF
      gff.first.should == expected_GFF
    
      # NC_003197 	69	2529131	2529056	Ala	GGC	0	0	86.51
      last_expected_GFF = expected_GFF = "NC_003197\ttRNAscan\ttRNA_gene\t2529056\t2529131\t86.51\t-\t0\tName=Ala GGC"
      gff.last.should == last_expected_GFF
    end
 
    it "should get all the rows" do
      pf = Phagefinder::File::Trnascan.new(@trnascan_file)
      pf.toGFF.size.should == 12 # Number of rows in the file
    end
  end
  
  context "empty file" do
    
    before :each do 
      @empty_file = Dir.pwd + "/spec/files/example_blank_tRNAscan.out"
    end
    
    it "should return an empty gff array" do
      pf = Phagefinder::File::Trnascan.new(@empty_file)
      pf.toGFF.should == []
    end
  end

end
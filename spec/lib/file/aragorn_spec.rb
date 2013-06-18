require 'phagefinder/file/aragorn'

describe Phagefinder::File::Aragorn do
  
  before :each do 
    @aragorn_file = Dir.pwd + "/spec/files/example_tmRNA_aragorn.out"
  end
  
  it "should throw an error if it is initialized without a file" do
   expect { pf = Phagefinder::File::Aragorn.new() }.to raise_error
  end
  
  it "should be initialized with an aragorn file" do
    expect { pf = Phagefinder::File::Aragorn.new(@aragorn_file) }.to_not raise_error
    # pf.should respond_to(:toGFF)
  end

  it "should parse the record into one block per result" do
    pf = Phagefinder::File::Aragorn.new(@aragorn_file)
    results = pf.get_record_blocks
    results.count.should == 2

    results.first['beginning'].should == "2843947"
    results.first['end'].should == "2844309"
    results.first['tag_peptide'].should == "ANDETYALAA**"
    results.first['sequence_acc'].should == "NC_003197"

  end

  
  # it "should get the strand from the orientation of the begin/end values" do
  #   pf = Phagefinder::File::Aragorn.new(@aragorn_file)
  #   pf.get_strand(123,456).should eq "+"
  #   pf.get_strand(567,456).should eq "-"
  # end
  
  # it "should parse the file to GFF" do
  #   pf = Phagefinder::File::Aragorn.new(@aragorn_file)
  #   expected_GFF = "NC_003197\tAragorn\ttRNA_gene\t2843947\t2844309\t0\t+\t0\tName=ANDETYALAA**"
  #   gff = pf.toGFF
  #   gff.first.should == expected_GFF
    
  #   # # NC_003197   69  2529131 2529056 Ala GGC 0 0 86.51
  #   last_expected_GFF = expected_GFF = "NC_003197\tAragorn\ttRNA_gene\t7701367\t7701729\t0\t-\t0\tName=Ala GGC"
  #   gff.last.should == last_expected_GFF
  # end
 
  # it "should get all the rows" do
  #   pf = Phagefinder::File::Aragorn.new(@aragorn_file)
  #   pf.toGFF.size.should == 2 # Number of rows in the file
  # end

end
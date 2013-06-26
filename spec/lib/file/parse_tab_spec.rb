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
    
    expected_GFF = "minirun\tPhageFinder\tphage_sequence\t961043\t1041426\t0\t+\t0\tName=Large prophage;phagefinder-#asmbl_id=minirun;phagefinder-genome_size=1050000;phagefinder-genome_gc=52.55;phagefinder-begin_region=961043;phagefinder-end_region=1041426;phagefinder-size_region=80384;phagefinder-label=Large;phagefinder-type=prophage;phagefinder-5prime_att=N.D.;phagefinder-3prime_att=N.D.;phagefinder-target=N.D.;phagefinder-region_gc=52.88;phagefinder-best_db_match=NC_001416;phagefinder-begin_gene=NP_459867.1;phagefinder-end_gene=NP_459936.1;phagefinder-#integrase_HMMs=1;phagefinder-#core_HMMs=5;phagefinder-#>noise_HMMs=0;phagefinder-#lytic_HMMs=3;phagefinder-#tail_HMMs=13;phagefinder-#Mu_HMMs=0;phagefinder-region_orientation=+;phagefinder-distance_int_to_att=0;phagefinder-#genes=77;phagefinder-#serine_recombinases=0"
    gff = pf.toGFF
    gff.size.should == 8
    gff.first.should == expected_GFF
  end

  it "should use the headers to create a large attribute array" do
    tab_file = Dir.pwd + "/spec/files/tab_example.txt"
    pf = Phagefinder::File::Tab.new(tab_file)
    pf.toGFF
    test_line = "minirun\t1050000\t52.55\t961043\t1041426\t80384\tLarge\tprophage\tN.D.\tN.D.\tN.D.\t52.88\tNC_001416\tNP_459867.1\tNP_459936.1\t1\t5\t0\t3\t13\t0\t+\t0\t77\t0"
    header_array = pf.line_to_header_array(test_line)
    header_array.size.should == 25

    header_array.first.should eq "phagefinder-#asmbl_id=minirun"
    header_array.last.should eq "phagefinder-#serine_recombinases=0"
  end


end
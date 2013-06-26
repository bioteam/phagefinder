require "#{File.dirname(__FILE__)}/../lib/phagefinder"

describe "it should have core methods" do
  
  it "should parse a ptt file" do
    ptt_file = Dir.pwd + "/spec/files/ptt_example.txt"
    expected_GFF = "ptt_example\tPhageFinder\tCDS\t190\t255\t0\t+\t0\tName=thr operon leader peptide;ID=NP_459006.1"
    Phagefinder.ptt_to_gff(ptt_file).first.should eq expected_GFF
  end
  
  it "should parse a tab file" do
    tab_file = Dir.pwd + "/spec/files/tab_example.txt"
    expected_GFF = "minirun\tPhageFinder\tphage_sequence\t961043\t1041426\t0\t+\t0\tName=Large prophage;phagefinder-#asmbl_id=minirun;phagefinder-genome_size=1050000;phagefinder-genome_gc=52.55;phagefinder-begin_region=961043;phagefinder-end_region=1041426;phagefinder-size_region=80384;phagefinder-label=Large;phagefinder-type=prophage;phagefinder-5prime_att=N.D.;phagefinder-3prime_att=N.D.;phagefinder-target=N.D.;phagefinder-region_gc=52.88;phagefinder-best_db_match=NC_001416;phagefinder-begin_gene=NP_459867.1;phagefinder-end_gene=NP_459936.1;phagefinder-#integrase_HMMs=1;phagefinder-#core_HMMs=5;phagefinder-#>noise_HMMs=0;phagefinder-#lytic_HMMs=3;phagefinder-#tail_HMMs=13;phagefinder-#Mu_HMMs=0;phagefinder-region_orientation=+;phagefinder-distance_int_to_att=0;phagefinder-#genes=77;phagefinder-#serine_recombinases=0"
    Phagefinder.tab_to_gff(tab_file).first.should eq expected_GFF
  end
  
  it "should parse an info file" do
    info_file = Dir.pwd + "/spec/files/info_example.txt"
    expected_GFF = "minirun\tPhageFinder\tCDS\t190\t255\t0\t+\t0\tName=thr operon leader peptide;ID=NP_459006.1"
    Phagefinder.info_to_gff(info_file).first.should eq expected_GFF
  end
  
  it "should parse an tRNAscan file" do
    trnascan_file = Dir.pwd + "/spec/files/trnascan_example.txt"
    expected_GFF = "NC_003197\ttRNAscan\ttRNA_gene\t290790\t290866\t88.37\t+\t0\tName=Ile GAT"
    Phagefinder.trnascan_to_gff(trnascan_file).first.should eq expected_GFF
  end
  
  it "should parse an Aragorn file" do
    aragorn_file = Dir.pwd + "/spec/files/example_tmRNA_aragorn.out"
    expected_GFF = "NC_003197\tAragorn\ttmRNA\t2843947\t2844309\t0\t+\t0\tName=ANDETYALAA**"
    Phagefinder.aragorn_to_gff(aragorn_file).first.should eq expected_GFF
  end


  it "should try to autodetect the file type from the name" do
    test_file_name = "test_info.txt"
    Phagefinder.identify_file_type(test_file_name).should == "info"
    
    test_file_name = "test_tab.txt"
    Phagefinder.identify_file_type(test_file_name).should == "tab"
    
    test_file_name = "test_file.ptt"
    Phagefinder.identify_file_type(test_file_name).should == "ptt"
    
    test_file_name = "tRNAscan.out"
    Phagefinder.identify_file_type(test_file_name).should == "trnascan"

    test_file_name = "tmRNA_aragorn.out"
    Phagefinder.identify_file_type(test_file_name).should == "aragorn"
  end
  
  it "should autoconvert known file types to GFF" do
    info_file = Dir.pwd + "/spec/files/example_info.txt"
    expected_GFF = "minirun\tPhageFinder\tCDS\t190\t255\t0\t+\t0\tName=thr operon leader peptide;ID=NP_459006.1"
    Phagefinder.file_to_gff(info_file).first.should eq expected_GFF
    
    tab_file = Dir.pwd + "/spec/files/example_tab.txt"
    expected_GFF = "minirun\tPhageFinder\tphage_sequence\t961043\t1041426\t0\t+\t0\tName=Large prophage;phagefinder-#asmbl_id=minirun;phagefinder-genome_size=1050000;phagefinder-genome_gc=52.55;phagefinder-begin_region=961043;phagefinder-end_region=1041426;phagefinder-size_region=80384;phagefinder-label=Large;phagefinder-type=prophage;phagefinder-5prime_att=N.D.;phagefinder-3prime_att=N.D.;phagefinder-target=N.D.;phagefinder-region_gc=52.88;phagefinder-best_db_match=NC_001416;phagefinder-begin_gene=NP_459867.1;phagefinder-end_gene=NP_459936.1;phagefinder-#integrase_HMMs=1;phagefinder-#core_HMMs=5;phagefinder-#>noise_HMMs=0;phagefinder-#lytic_HMMs=3;phagefinder-#tail_HMMs=13;phagefinder-#Mu_HMMs=0;phagefinder-region_orientation=+;phagefinder-distance_int_to_att=0;phagefinder-#genes=77;phagefinder-#serine_recombinases=0"
    Phagefinder.file_to_gff(tab_file).first.should eq expected_GFF
    
    
    trnascan_file = Dir.pwd + "/spec/files/tRNAscan.out"
    expected_GFF = "NC_003197\ttRNAscan\ttRNA_gene\t290790\t290866\t88.37\t+\t0\tName=Ile GAT"
    Phagefinder.file_to_gff(trnascan_file).first.should eq expected_GFF

    aragorn_file = Dir.pwd + "/spec/files/example_tmRNA_aragorn.out"
    expected_GFF = "NC_003197\tAragorn\ttmRNA\t2843947\t2844309\t0\t+\t0\tName=ANDETYALAA**"
    Phagefinder.file_to_gff(aragorn_file).first.should eq expected_GFF

     aragorn_file = Dir.pwd + "/spec/files/example_one_hit_tmRNA_aragorn.out"
    expected_GFF = "NC_003197\tAragorn\ttmRNA\t2843947\t2844309\t0\t+\t0\tName=ANDETYALAA**"
    Phagefinder.file_to_gff(aragorn_file).last.should eq expected_GFF

  end
  
end
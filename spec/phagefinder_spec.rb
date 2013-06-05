require "#{File.dirname(__FILE__)}/../lib/phagefinder"

describe "it should have core methods" do
  
  it "should parse a ptt file" do
    ptt_file = Dir.pwd + "/spec/files/ptt_example.txt"
    expected_GFF = "ptt_example\tPhageFinder\tCDS\t190\t255\t0\t+\t0\tName=thr operon leader peptide;ID=NP_459006.1"
    Phagefinder.ptt_to_gff(ptt_file).first.should eq expected_GFF
  end
  
  it "should parse a tab file" do
    tab_file = Dir.pwd + "/spec/files/tab_example.txt"
    expected_GFF = "minirun\tPhageFinder\tphage_sequence\t961043\t1041426\t0\t+\t0\tName=Large prophage"
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
  
  it "should try to autodetect the file type from the name" do
    test_file_name = "test_info.txt"
    Phagefinder.identify_file_type(test_file_name).should == "info"
    
    test_file_name = "test_tab.txt"
    Phagefinder.identify_file_type(test_file_name).should == "tab"
    
    test_file_name = "test_file.ptt"
    Phagefinder.identify_file_type(test_file_name).should == "ptt"
    
    test_file_name = "tRNAscan.out"
    Phagefinder.identify_file_type(test_file_name).should == "trnascan"
  end
  
  it "should autoconvert known file types to GFF" do
    info_file = Dir.pwd + "/spec/files/example_info.txt"
    expected_GFF = "minirun\tPhageFinder\tCDS\t190\t255\t0\t+\t0\tName=thr operon leader peptide;ID=NP_459006.1"
    Phagefinder.file_to_gff(info_file).first.should eq expected_GFF
    
    tab_file = Dir.pwd + "/spec/files/example_tab.txt"
    expected_GFF = "minirun\tPhageFinder\tphage_sequence\t961043\t1041426\t0\t+\t0\tName=Large prophage"
    Phagefinder.file_to_gff(tab_file).first.should eq expected_GFF
    
    
    trnascan_file = Dir.pwd + "/spec/files/tRNAscan.out"
    expected_GFF = "NC_003197\ttRNAscan\ttRNA_gene\t290790\t290866\t88.37\t+\t0\tName=Ile GAT"
    Phagefinder.file_to_gff(trnascan_file).first.should eq expected_GFF
  end
  
end
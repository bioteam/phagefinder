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
    tab_file = Dir.pwd + "/spec/files/info_example.txt"
    expected_GFF = "minirun\tPhageFinder\tCDS\t190\t255\t0\t+\t0\tName=thr operon leader peptide;ID=NP_459006.1"
    Phagefinder.info_to_gff(tab_file).first.should eq expected_GFF
  end
  
end
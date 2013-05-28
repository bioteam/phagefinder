require 'phagefinder'

describe Phagefinder::Tab do
  
  before :each do 
    @tab_file = Dir.pwd + "/spec/files/tab_example.txt"
  end
  
  it "should throw an error if it is initialized without a file" do
   expect { pf = Phagefinder::Tab.new() }.to raise_error
  end
  
  it "should be initialized with a .tab file" do
    expect { pf = Phagefinder::Tab.new(@tab_file) }.to_not raise_error
    # pf.should respond_to(:toGFF)
  end
  
  it "should split the output line by tab" do
    line = "minirun	1050000	52.55	961043	1041426	80384	Large	prophage	N.D.	N.D.	N.D.	52.88	NC_001416	NP_459867.1	NP_459936.1	1	5	0	3	13	0	+	0	77	0"
    pf = Phagefinder::Tab.new(@tab_file)
    pf.split_line_to_gff(line).split("\t").count.should == 9
    
  end
  
  it "should parse the file to GFF" do
    tab_file = Dir.pwd + "/spec/files/tab_example.txt"
    pf = Phagefinder::Tab.new(tab_file)
    
    expected_GFF = "minirun\tPhageFinder\tphage_sequence\t961043\t1041426\t0\t+\t0\tName=Large prophage"
    pf.toGFF.first.should == expected_GFF
  end

  

end
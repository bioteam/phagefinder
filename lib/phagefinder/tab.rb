
module Phagefinder
  
  #  Class for dealing with the .tab output file from a PhageFinder run
  class Tab
    
    attr_accessor :file
    
    def initialize(file)
      # run_preflight_checks(file)
      @file = File.open(file, "r")

    end
    
    
    def run_preflight_checks(file)
      unless File.exists?(@file)
        raise "Tab file #{@file} cannot be found..."
      end
      
      unless File.readable?(@file)
        raise "Tab file #{@file} cannot be read..."
      end
      
    end
    
    # Converts a PhageFinder tab file to GFF3 output
    def toGFF
      return parse_tab_file
    end
    
    def parse_tab_file
      lines = File.readlines(@file)
      headers = lines.first.split("\t")
      
      # remove the header line
      lines.delete_at(0)
      
      gff = []
      lines.each do |l|
        gff << split_line_to_gff(l)
      end
      return gff
    end
    
    def split_line_to_gff(line)
      cols = line.split("\t")
      gff = [cols[0],"PhageFinder","phage_sequence",cols[3],cols[4],"0",cols[21],"0","Name=#{cols[6]} #{cols[7]}"]
      return gff.join("\t")
    end
    
  end
end

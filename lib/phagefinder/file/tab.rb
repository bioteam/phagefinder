require "phagefinder/file/utils"

module Phagefinder::File
  
  #  Class for dealing with the .tab output file from a PhageFinder run
  class Tab < Phagefinder::File::Utils
    
    # Converts a PhageFinder tab file to GFF3 output
    def toGFF
      return parse_file(:remove_headers => true)
    end
    
    def line_to_gff(line)
      cols = line.split("\t")
      gff = [cols[0],"PhageFinder","phage_sequence",cols[3],cols[4],"0",cols[21],"0","Name=#{cols[6]} #{cols[7]}"]
      return gff.join("\t")
    end
    
  end
end

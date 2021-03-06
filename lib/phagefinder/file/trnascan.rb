require "phagefinder/file/utils"

module Phagefinder::File
  
  #  Class for dealing with the .tab output file from a PhageFinder run
  class Trnascan < Phagefinder::File::Utils
    
    # Converts a PhageFinder tRNAscan file to GFF3 output
    def toGFF
      return parse_file(:remove_headers => true, :header_line_count => 3)
    end
    
    def line_to_gff(line)
      # split by tab and remove any extraneous whitespace that seems to be included in the file
      cols = line.split("\t").collect{|x| x.strip}
      strand = self.get_strand(cols[2],cols[3])
      (start,stop) = self.orient_coordinates(cols[2],cols[3])
      gff = [cols[0],"tRNAscan","tRNA_gene",start, stop,cols[8],strand,"0","Name=#{cols[4]} #{cols[5]}"]
      return gff.join("\t")
    end
    
  end
end

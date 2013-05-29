require "phagefinder/file/utils"

module Phagefinder::File
  
  #  Class for dealing with the .tab output file from a PhageFinder run
  class Ptt < Phagefinder::File::Utils
    
    # Converts a PhageFinder tab file to GFF3 output
    def toGFF
      return parse_file(:remove_headers => false)
    end
    
    def line_to_gff(line)
      cols = line.split("\t")
      start, stop = parse_range(cols[0])
      name = cols[8].strip
      gff = [self.filename,"PhageFinder","CDS",start,stop,"0",cols[1],"0","Name=#{name};ID=#{cols[3]}"]
      return gff.join("\t")
    end
    
    def parse_range(range)
      range.split("..")
    end
  end
end

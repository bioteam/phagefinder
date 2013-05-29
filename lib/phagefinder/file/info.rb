require "phagefinder/file/utils"

module Phagefinder::File

  #  Class for dealing with the .info output file from a PhageFinder run
  class Info < Phagefinder::File::Utils

    def toGFF
      return parse_file(:remove_headers => false)
    end
    
    
    def line_to_gff(line)
      cols = line.split("\t")
      gff = [cols[0],"PhageFinder","phage_sequence",cols[3],cols[4],"0","","0","Name=#{cols[5].strip}"]
      return gff.join("\t")
    end
    
  end
end
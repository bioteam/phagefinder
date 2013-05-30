require "phagefinder/file/utils"

module Phagefinder::File

  #  Class for dealing with the .info output file from a PhageFinder run
  class Info < Phagefinder::File::Utils

    def toGFF
      return parse_file(:remove_headers => false)
    end
    
    
    def line_to_gff(line)
      cols = line.split("\t")
      name = cols[5].split(";").first
      gff = [cols[0],"PhageFinder","CDS",cols[3],cols[4],"0","+","0","Name=#{name};ID=#{cols[2]}"]
      return gff.join("\t")
    end
    
    
  end
end
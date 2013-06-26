require "phagefinder/file/utils"

module Phagefinder::File
  
  #  Class for dealing with the .tab output file from a PhageFinder run
  class Tab < Phagefinder::File::Utils
    
    # Converts a PhageFinder tab file to GFF3 output
    def toGFF
      return parse_file(:remove_headers => true)
    end
    
    def line_to_gff(line)
      cols = line.split(/\t/)
      header_array = line_to_header_array(line).join(';')
      (start,stop) = self.orient_coordinates(cols[3],cols[4])
      gff = [cols[0],"PhageFinder","phage_sequence",start, stop,"0",cols[21],"0","Name=#{cols[6]} #{cols[7]};#{header_array}"]
      return gff.join("\t")
    end
    
    def line_to_header_array(line)
      cols = line.strip.split(/\t/)
      header_array = []
      if @headers.size == cols.size 
        @headers.each_with_index do |k,i|
          key = "phagefinder-#{k}"
          header_array << "#{key}=#{cols[i]}"
        end
      end
      return header_array
    end

  end
end

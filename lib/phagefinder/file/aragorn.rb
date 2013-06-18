require "phagefinder/file/utils"

module Phagefinder::File
  
  #  Class for dealing with the aragorn output file from a PhageFinder run
  class Aragorn < Phagefinder::File::Utils
    
    # Converts a PhageFinder Aragorn file to GFF3 output
    def toGFF
      return parse_file
    end
    
    def line_to_gff(line_hash)

      strand = self.get_strand(line_hash['beginning'], line_hash['end'])
      (start,stop) = self.orient_coordinates(line_hash['beginning'], line_hash['end'])
      gff = [line_hash['sequence_acc'],"Aragorn","tmRNA",start, stop,"0",strand,"0","Name=#{line_hash['tag_peptide']}"]
      return gff.join("\t")
    end
    
    # parse the file by first breaking into blocks of lines for each result
    # then parse these blocks to get the correct data into a hash
    # then convert this hash to gff
    def parse_file
      parsed_result_blocks = get_record_blocks

      gff_array = []
      parsed_result_blocks.each do |b|
        gff_array << line_to_gff(b)
      end
      return gff_array
    end


    # Parse the aragorn file to find blocks of lines corresponding to
    # a hit, use the Location line to signify a new result
    def get_record_blocks

      blocks = []
      current_block = nil

      File.readlines(@file).each do |l|

        # start of a new aragorn result
        if l =~ /^Location \[(\d+),(\d+)\]$/

          if current_block
            blocks << parse_block(current_block)
            current_block = []
          else 
            current_block = Array.new
          end
        end

        if current_block
          current_block << l
        end 

      end
      blocks << parse_block(current_block)

      return blocks
    end


    # Parse each block of lines to pull out the key information needed
    # to create GFF
    def parse_block(b)
      results = {}
      b.each do |line|

        puts line

        if line =~ /^Location \[(\d+),(\d+)\]$/
          results['beginning'] = $1
          results['end'] = $2
        elsif line =~ /^tmRNA Sequence in\s(\w+)/
          results['sequence_acc'] = $1
        elsif line =~ /^Tag peptide:\s+(.+)/
          results['tag_peptide'] = $1
        end
      end

      return results
    end

  end

end

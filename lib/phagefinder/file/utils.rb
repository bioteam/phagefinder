module Phagefinder::File
  
  class Utils
    
    attr_accessor :file, :filename
    
    def initialize(file)
      @file = File.open(file, "r")
      @filename = parse_filename(file)
    end
    
    def parse_filename(file)
      extension = File.extname(file)
      filename = File.basename(file, extension) 
      return filename
    end
    
    def parse_file(params)
      
      remove_headers = params[:remove_headers] || false
      header_line_count = params[:header_line_count] || 1
      
      lines = File.readlines(@file)
      
      if remove_headers
        (1..header_line_count).each do |c|
          lines.delete_at(0)
        end
      end
      
      gff = []
      lines.each do |l|
        gff << line_to_gff(l)
      end
      return gff
    end
    
    def line_to_gff(line)

    end
    
    def get_strand(seq_start, seq_end)
      if seq_start < seq_end
        '+'
      else
        '-'
      end
    end
    
    # Ensure that the start coordinate is always <= to the end coordinates
    def orient_coordinates(a,b)
      int_a = a.to_i
      int_b = b.to_i
      sorted_coords = Array.new
      if int_a > int_b
        sorted_coords = [int_b,int_a]
      else
        sorted_coords = [int_a,int_b]
      end
      return sorted_coords
    end
    
  end
end
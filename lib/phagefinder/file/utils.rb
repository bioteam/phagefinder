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
    
  end
end
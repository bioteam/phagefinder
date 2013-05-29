module Phagefinder::File
  
  class Utils
    
    attr_accessor :file
    
    def initialize(file)
      @file = File.open(file, "r")
    end
    
    def parse_file(params)
      
      remove_headers = params[:remove_headers] || false
      
      lines = File.readlines(@file)
      
      if remove_headers
        lines.delete_at(0)
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
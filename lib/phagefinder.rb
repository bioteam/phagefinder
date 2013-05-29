require "#{File.dirname(__FILE__)}/phagefinder/version"
# require "#{File.dirname(__FILE__)}/phagefinder/file"


module Phagefinder

  def Phagefinder.ptt_to_gff(file)
    parser = Phagefinder::File::Ptt.new(file)
    return parser.toGFF
  end
  
  def Phagefinder.tab_to_gff(file)
    parser = Phagefinder::File::Tab.new(file)
    return parser.toGFF
  end
  
  def Phagefinder.info_to_gff(file)
    parser = Phagefinder::File::Info.new(file)
    return parser.toGFF
  end
  
end

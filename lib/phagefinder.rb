require "#{File.dirname(__FILE__)}/phagefinder/version"
require "#{File.dirname(__FILE__)}/phagefinder/file/info"
require "#{File.dirname(__FILE__)}/phagefinder/file/tab"
require "#{File.dirname(__FILE__)}/phagefinder/file/ptt"
require "#{File.dirname(__FILE__)}/phagefinder/file/trnascan"


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
  
  def Phagefinder.trnascan_to_gff(file)
    parser = Phagefinder::File::Trnascan.new(file)
    return parser.toGFF
  end

end

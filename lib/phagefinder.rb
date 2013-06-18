require "#{File.dirname(__FILE__)}/phagefinder/version"
require "#{File.dirname(__FILE__)}/phagefinder/file/info"
require "#{File.dirname(__FILE__)}/phagefinder/file/tab"
require "#{File.dirname(__FILE__)}/phagefinder/file/ptt"
require "#{File.dirname(__FILE__)}/phagefinder/file/trnascan"
require "#{File.dirname(__FILE__)}/phagefinder/file/aragorn"

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

  def Phagefinder.aragorn_to_gff(file)
    parser = Phagefinder::File::Aragorn.new(file)
    return parser.toGFF
  end
  
  def Phagefinder.identify_file_type(file_name)
    if file_name =~ /.+_info.txt$/
      "info"
    elsif file_name =~ /.+_tab.txt$/
      "tab"
    elsif file_name =~ /.+.ptt$/
      "ptt"
    elsif file_name =~ /tRNAscan.out$/
      "trnascan"
    elsif file_name =~ /.*?tmRNA_aragorn.out$/
      "aragorn"
    else
      "unknown"
    end
  end
  
  def Phagefinder.file_to_gff(file)
    case Phagefinder.identify_file_type(file)
    when "info"
      Phagefinder.info_to_gff(file)
    when "tab"
      Phagefinder.tab_to_gff(file)
    when "ptt"
      Phagefinder.ptt_to_gff(file)
    when "trnascan"
      Phagefinder.trnascan_to_gff(file)
    when "aragorn"
      Phagefinder.aragorn_to_gff(file)
    when "unknown"
      raise "unidentified file type for #{file} - could not parse automatically"
    else
      raise "unidentified file type for #{file} - could not parse automatically"
    end
  end
end

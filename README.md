# Phagefinder

The Phagefinder gem encapsulates a variety of functions for dealing with PhageFinder output files.

## Installation

Add this line to your application's Gemfile:

    gem 'phagefinder', :git => 'git://github.com/bioteam/phagefinder.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phagefinder

## Usage

### Parsing PhageFinder 'tab' files to GFF3

The Phagefinder::Tab module can be used to convert a PhageFinder tab file into appropriate GFF3

	pf_parser = Phagefinder::Tab.new("/path/to/phagefinder/output/the_tab.txt")
	gff_feature_array = pf_parser.toGFF
	gff_feature_array.each do |gff_line|
		puts gff_line
	end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

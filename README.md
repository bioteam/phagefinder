# Phagefinder

The Phagefinder gem encapsulates a variety of functions for dealing with PhageFinder output files.

## Installation

Add this line to your application's Gemfile:

    gem 'phagefinder', :git => 'git@github.com:bioteam/phagefinder.git'

And then execute:

    $ bundle install


## Usage

### Phagefinder::Tab

The Tab module is dedicated to operations on the tab output file. A typical file looks something like this with a single header line and then multiple feature lines, all tab delimited.

	#asmbl_id	genome_size	genome_gc	begin_region	end_region	size_region	label	type	5prime_att	3prime_att	target	region_gc	best_db_match	begin_gene	end_gene	#integrase_HMMs	#core_HMMs	#>noise_HMMs	#lytic_HMMs	#tail_HMMs	#Mu_HMMs	region_orientation	distance_int_to_att	#genes	#serine_recombinases
	minirun	1050000	52.55	961043	1041426	80384	Large	prophage	N.D.	N.D.	N.D.	52.88	NC_001416	NP_459867.1	NP_459936.1	1	5	0	3	13	0	+	0	77	0

#### Parsing PhageFinder 'tab' files to GFF3

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

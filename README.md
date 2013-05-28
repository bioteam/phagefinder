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

The Phagefinder::Tab module can be used to convert a PhageFinder tab file into appropriate GFF3.

For more information on the GFF3 file format and what each column means see: http://www.sequenceontology.org/gff3.shtml. The 9 columns are shown below, along with the column from the Phagefinder tab file that I have used to provide the data for the GFF column.

1.	Seqid 	-> asmbl_id
2.	Source	-> "PhageFinder" (Algorithm name)
3.	Type	-> phage_sequence (SO:0001042, Sequence ontology term)
4.	Start	-> begin_region
5.	End		-> end_region
6.	Score	-> set to '0'?
7.	Strand	-> region_orientation
8.	Phase	-> set to '0'?
9.	Attributes
	* Name=#{label},#{type}


A script to parse a tab file into GFF might look something like this:

	```ruby
	require 'phagefinder'

	pf_parser = Phagefinder::Tab.new("/path/to/phagefinder/output/the_tab.txt")
	gff_feature_array = pf_parser.toGFF
	gff_feature_array.each do |gff_line|
		puts gff_line
	end
	```
	
	# Gives an output that looks something like this (tab delimuted)
	minirun	PhageFinder	phage_sequence	961043	1041426	0	+	0	Name=Large prophage

## Contributing

I am using rspec to write tests for the gem as it is developed. You can run these tests from the command line as follows

	$ cd phagefinder
	$ rspec
	

The output should looks something like this:

	$ 	....
		Finished in 0.00138 seconds
		4 examples, 0 failures

If you want to contribute to the code, here's how to do it:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write appropriate tests using rspec, make sure they all pass!
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

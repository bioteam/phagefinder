# Phagefinder

The Phagefinder gem encapsulates a variety of functions for dealing with PhageFinder output files.

## Installation

Add this line to your application's Gemfile:

    gem 'phagefinder', :git => 'git@github.com:bioteam/phagefinder.git'

And then execute:

    $ bundle install


## Usage

The Phagefinder module provides some core methods to parse the Phagefinder output files into GFF. This parent methods should be called in preference to instantiating the submodules (eg Phagefinder::File::Info, etc) as this will be a more consistent interface going forward and by using these methods you will be more insulated from any underlying changes to the codebase.

```ruby
require 'phagefinder'

    # could also be Phagefinder.info_to_gff("/path/to/the_info.txt")
	# or Phagefinder.ptt_to_gff("/path/to/the/contig.ptt")
tab_gff_array = Phagefinder.tab_to_gff('/path/to/tab.txt')
tab_gff_array.each do |line|
	puts "GFF: #{line}"
end
```


## Submodules


### Phagefinder::File::Tab

The Tab module is dedicated to operations on the tab output file. A typical file looks something like this with a single header line and then multiple feature lines, all tab delimited.

	#asmbl_id	genome_size	genome_gc	begin_region	end_region	size_region	label	type	5prime_att	3prime_att	target	region_gc	best_db_match	begin_gene	end_gene	#integrase_HMMs	#core_HMMs	#>noise_HMMs	#lytic_HMMs	#tail_HMMs	#Mu_HMMs	region_orientation	distance_int_to_att	#genes	#serine_recombinases
	minirun	1050000	52.55	961043	1041426	80384	Large	prophage	N.D.	N.D.	N.D.	52.88	NC_001416	NP_459867.1	NP_459936.1	1	5	0	3	13	0	+	0	77	0

#### Parsing PhageFinder 'tab' files to GFF3

The Phagefinder::File::Tab module can be used to convert a PhageFinder tab file into appropriate GFF3.

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


### Phagefinder::File::Info

The Phagefinder::File::Info module is dedicated to operations on the info.txt output file. A typical file looks something like this with no header line and then multiple tab delimited lines indicating prediced gene locations against the parent contig

	minirun	1050000	NP_459006.1	190	255	thr operon leader peptide; -


#### Parsing PhageFinder 'info' files to GFF3

The Phagefinder::File::Info module can be used to convert a PhageFinder info file into appropriate GFF3.

1.	Seqid 	-> Column 1
2.	Source	-> "PhageFinder" (Algorithm name)
3.	Type	-> CDS
4.	Start	-> Column 4
5.	End		-> Column 5
6.	Score	-> 0
7.	Strand	-> + (Default - not parsed from any data currently)
8.	Phase	-> 0
9.	Attributes
	* Name=#{Column 6};ID=#{Column 3}


### Phagefinder::File::Ptt

The Phagefinder::File::Ptt module is dedicated to operations on the *.ptt output file. A typical file looks something like this with no header line and then multiple tab delimited lines indicating prediced gene locations against the parent contig

		190..255	+	21	NP_459006.1	-	-	1	-	thr operon leader peptide


#### Parsing PhageFinder 'ptt' files to GFF3

The Phagefinder::File::Ptt module is responsible for parsing the *.ptt files generated by Phagefinder and returning appropriately formatted GFF3.

Here's how we are parsing the *.ptt file into GFF. One complicating factor with this file is that the value for the seqid column is not contained within the ptt file itself, rather it is in the filename, eg. minirun.ptt and the seqid value should be 'minirun'. The Phagefinder::File::Utils contains a method to pull out the filename for just this purpose.

1.	Seqid 	-> the parent filename without '.ptt'
2.	Source	-> "PhageFinder" (Algorithm name)
3.	Type	-> CDS
4.	Start	-> First part of column 1
5.	End		-> Second part of column 1
6.	Score	-> 0
7.	Strand	-> Column 2
8.	Phase	-> 0
9.	Attributes
	* Name=#{Column 9};ID=#{Column 4}
		
		
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

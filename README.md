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

    # could also be:
	# Phagefinder.info_to_gff("/path/to/the_info.txt")
	# Phagefinder.ptt_to_gff("/path/to/the/contig.ptt")
	# Phagefinder.trnascan_to_gff("/path/to/the/tRNAscan.out")
	# Phagefinder.aragorn_to_gff("/path/to/the/tmRNA_aragorn.out")
	tab_gff_array = Phagefinder.tab_to_gff('/path/to/tab.txt')
	tab_gff_array.each do |line|
		puts "GFF: #{line}"
	end
	
	# there is also a generic Phagefinder.file_to_gff(file) method that attempts to
	# identify the file type by its file name
	
	# The gem will throw an exception if the input file can not be found or read
	# so you should plan to rescue this and do something sensible
	# If the file is empty (zero rows) then you will get an empty GFF array
	begin
		tab_gff_array = Phagefinder.file_to_gff('path/to/example_tab.txt')
	rescue
		puts "There has been a problem parsing your file to GFF"
	end
```


## Submodules


### Phagefinder::File::Tab

The Tab module is dedicated to operations on the tab output file. A typical file looks something like this with a single header line and then multiple feature lines, all tab delimited.

	#asmbl_id	genome_size	genome_gc	begin_region	end_region	size_region	label	type	5prime_att	3prime_att	target	region_gc	best_db_match	begin_gene	end_gene	#integrase_HMMs	#core_HMMs	#>noise_HMMs	#lytic_HMMs	#tail_HMMs	#Mu_HMMs	region_orientation	distance_int_to_att	#genes	#serine_recombinases
	minirun	1050000	52.55	961043	1041426	80384	Large	prophage	N.D.	N.D.	N.D.	52.88	NC_001416	NP_459867.1	NP_459936.1	1	5	0	3	13	0	+	0	77	0

#### Parsing PhageFinder 'tab' files to GFF3

The Phagefinder::File::Tab module can be used to convert a PhageFinder tab file into appropriate GFF3.

For more information on the GFF3 file format and what each column means see: http://www.sequenceontology.org/gff3.shtml. The 9 columns are shown below, along with the column from the Phagefinder tab file that I have used to provide the data for the GFF column. To facilitate subsequent data analysis all the columns of the Tab output are also included in the attributes column with the attribute tag name following the format 'phagefinder-[column-header-name]=[column-value]', eg. "phagefinder-#asmbl_id=minirum"

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
	* phagefinder-#asmbl_id=#{asmbl_id};phagefinder-genome_size=#{size}; (etc)


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
7.	Strand	-> '+' if start < end, '-' if start > end
8.	Phase	-> 0
9.	Attributes
	* Name=#{Column 6};ID=#{Column 3}


### Phagefinder::File::Ptt

The Phagefinder::File::Ptt module is dedicated to operations on the *.ptt output file. A typical file looks something like this with no header line and then multiple tab delimited lines indicating predicted gene locations against the parent contig

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


### Phagefinder::File::Trnascan

The Phagefinder::File::Ptt module is dedicated to operations on the tRNAscan.out output file. 

 A typical file looks something like this with three header lines and then multiple tab delimited lines indicating predicted tRNA locations against the parent contig

	Sequence  		tRNA   	Bounds 	tRNA	Anti	Intron Bounds	Cove
	Name      	tRNA #	Begin  	End    	Type	Codon	Begin	End	Score
	--------  	------	----   	------ 	----	-----	-----	----	------
	NC_003197 	1	290790 	290866 	Ile	GAT	0	0	88.37
	NC_003197 	2	290976 	291051 	Ala	TGC	0	0	88.77
	NC_003197 	3	294828 	294904 	Asp	GTC	0	0	92.84

#### Parsing PhageFinder 'tRNAscan.out' files to GFF3

The Phagefinder::File::Trnascan module is responsible for parsing the tRNAscan.out files generated by Phagefinder and returning appropriately formatted GFF3.

Here's how we are parsing the tRNAscan.out file into GFF:

1.	Seqid 	-> Sequence Name (column 1)
2.	Source	-> "tRNAscan" (Algorithm name)
3.	Type	-> tRNA_gene (SO:0001272)
4.	Start	-> Column 2
5.	End		-> Column 3
6.	Score	-> Column 8
7.	Strand	-> '+' if start < end, '-' if start > end
8.	Phase	-> 0
9.	Attributes
	* Name=#{Column 4} #{Column 5} #tRNA type and Codon, eg 'Ile GAT'
		


### Phagefinder::File::Aragorn

The Phagefinder::File::Aragorn module is dedicated to operations on the tmRNA_aragorn.out output file. 

 A typical file contains one or more blocks of lines corresponding to the hits found by the algorithm

	1.
	Location [2843947,2844309]
	tmRNA Sequence in NC_003197 Salmonella enterica subsp. enterica serovar Typhimurium str. LT2 chro

	1   .   10    .   20    .   30    .   40    .   50
	ggggctgattctggattcgacgggatttGCGAAACCCAAGGTGCATGCCG
	AGGGGCGGTTGGCCTCGTAAAAAGCCGCAAAAAAATAGTCgcaaacgacg
	aaacctacgctttagcagcttaataaCCTGCTTAGAGCCCTCTCTCCCTA
	GCCTCCGCTCTTAGGACGGGGATCAAGAGAGGTCAAACCCAAAAGAGATC
	GCGCGGATGCCCTGCCTGGGGTTGAAGCGTTAAAACGAATCAGGCTAGTC
	TGGTAGTGGCGTGTCCGTCCGCAGGTGCCAGGCGAATGTAAAGACTGACT
	AAGCATGTAGTACCGAGGATGTAGgaatttcggacgcgggttcaactccc
	gccagctccacca

	Resume consensus sequence (at 84): aatagtcgcaaacgacga

	Tag peptide (at 91)
	Tag sequence: gca-aac-gac-gaa-acc-tac-gct-tta-gca-gct-taa-taa
	Tag peptide:  Ala-Asn-Asp-Glu-Thr-Tyr-Ala-Leu-Ala-Ala-Stop-Stop
	Tag peptide:  ANDETYALAA**
	Match with tmRNA tags from:
	Neisseria gonorrhoeae, Neisseria meningitidis, Neisseria lactamica
	Chromobacterium violaceum, Methylobacillus glycogenes, Methylobacillus flagellatus
	Moraxella catarrhalis, Uncultured U04, Acinetobacter ADP1
	Uncultured RCA4, Uncultured LEM1, Salmonella typhimurium
	Salmonella typhi, Salmonella enterica 1, Salmonella enterica 3
	Salmonella enterica 5, Uncultured VLS5, Uncultured FS1

#### Parsing PhageFinder 'tmRNA_aragorn.out' files to GFF3

The Phagefinder::File::Aragorn module is responsible for parsing the tmRNA_aragorn.out files generated by Phagefinder and returning appropriately formatted GFF3.

Here's how we are parsing the tmRNA_aragorn.out file into GFF:

1.	Seqid 	-> The first word after 'tmRNA Sequence in ... '
2.	Source	-> "Aragorn" (Algorithm name)
3.	Type	-> tmRNA (SO:0000584)
4.	Start	-> First number in Location line
5.	End		-> Second number from Location line
6.	Score	-> 0
7.	Strand	-> '+' if start < end, '-' if start > end
8.	Phase	-> 0
9.	Attributes
	* Name=#{Tag peptide} #tag peptide at the insertion site, eg 'ANDETYALAA**'

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

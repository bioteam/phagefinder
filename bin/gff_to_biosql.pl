#!/usr/bin/env perl

=head1 NAME

gff_to_biosql.pl

=head1 USAGE

Specify a sequence file (Genbank or Fasta) and one or more GFF3 files. For example:

./gff_to_biosql.pl -s NC_003197.gbk NC_003197_tab.gff NC_003197_tRNAscan.gff

or 

./gff_to_biosql.pl -s NC_003197.fa NC_003197_ptt.gff NC_003197_tab.gff NC_003197_tRNAscan.gff

This creates Bioentry and Seqfeature records.

Specify an accession if the sequence already exists in the database:

./gff_to_biosql.pl -a NC_003197 NC_003197_tab.gff NC_003197_tRNAscan.gff

This adds Seqfeature records to an existing Bioentry record.

=head1 NOTES

Followed by:

bin/prepare-refseqs.pl --fasta ~/dev/gff_to_JBrowse/NC_003197.fa 
bin/biodb-to-json.pl --conf ~/dev/gff_to_JBrowse/NC_003197.json 

Script currently assumes there's a single sequence in the sequence file.

Required in my.cnf, for big sequences, something like:

max_allowed_packet=1000000000
net_buffer_length=10000000

=cut

use strict;
use Bio::Tools::GFF;
use Getopt::Long;
use Bio::SeqIO;
use Bio::DB::BioDB;

my ($verbose,$seq_file,$accession,$seq,$adp1);
my ( $db_name, $host, $driver, $user, $pass ) =
  qw(biosql localhost mysql root 123456);
my $namespace = 'Phage Database';

GetOptions(
    "s=s" => \$seq_file,
    "v"   => \$verbose,
    "d=s" => \$db_name,
    "u=s" => \$user,
    "p=s" => \$pass,
    "a=s" => \$accession
);

die "No GFF files specified"   if ! @ARGV;

my $dsn = "DBI:$driver:database=$db_name;host=$host";

my $db = Bio::DB::BioDB->new(
    -database => 'biosql',
    -host     => $host,
    -dbname   => $db_name,
    -driver   => $driver,
    -user     => $user,
    -pass     => $pass,
    -dsn      => $dsn,
);

if ($seq_file) {
    my $seq_io = Bio::SeqIO->new( -file => $seq_file );
    $seq = $seq_io->next_seq;
    $seq->namespace($namespace);

    # Populate bioentry.accession
    $seq->accession_number( $seq->display_id );
    print "Parsed $seq_file\n" if $verbose;
}
elsif ($accession) {
    my $tseq = Bio::Seq->new(
        -accession_number => $accession,
        -namespace        => $namespace
    );
    $adp1 = $db->get_object_adaptor($tseq);
    $seq = $adp1->find_by_unique_key($tseq);
} else {
  die "No accession or sequence file specified";
}

for my $gff_file (@ARGV) {
    open IN, $gff_file or die "Can not open GFF file $gff_file";

    while (<IN>) {
        my @line = split "\t";
        my $feat = Bio::SeqFeature::Generic->new;

        $feat->source_tag($line[1]);
        $feat->primary_tag($line[2]);
        $feat->start($line[3]);
        $feat->end($line[4]);
        $feat->add_tag_value('Score',$line[5]);
        $line[6] eq '+' ? $feat->strand(1) : $feat->strand(-1);
        # 'phase' is undefined
        my @attrs = split ';', $line[8];
        for my $attr ( @attrs ) {
            $attr =~ /^\s*(.+)\s*=\s*(.+)\s*$/;
            $feat->add_tag_value($1,$2);
        }

        $seq->add_SeqFeature($feat);
    }
}

if ($seq_file) {
    my $adp2  = $db->get_object_adaptor($seq);
    my $pseq = $db->create_persistent($seq);
    $pseq->store;
    $adp2->commit;
}
elsif ($accession) {
    $seq->store;
    $adp1->commit;
}


print "Loaded ",$seq->display_id,"\n" if $verbose;

__END__

my $gff_io = Bio::Tools::GFF->new( -file => $gff_file, -gff_version => 3 );

while ( my $feature = $gff_io->next_feature() ) {
  $seq->add_SeqFeature($feature);
}
$gff_io->close();
print "Parsed $gff_file\n" if $verbose;

0  Bio::SeqFeature::Generic=HASH(0x7f9cf407fb90)
   '_gsf_frame' => 0
   '_gsf_seq_id' => 'NC_003197'
   '_gsf_tag_hash' => HASH(0x7f9cf407fb48)
      'Name' => ARRAY(0x7f9cf407fea8)
         0  'Ile GAT'
      'score' => ARRAY(0x7f9cf407ffe0)
         0  88.37
   '_location' => Bio::Location::Simple=HASH(0x7f9cf407fef0)
      '_end' => 290866
      '_location_type' => 'EXACT'
      '_start' => 290790
      '_strand' => 1
   '_parse_h' => HASH(0x7f9cf40a0920)
        empty hash
   '_primary_tag' => 'tRNA_gene'
   '_root_cleanup_methods' => ARRAY(0x7f9cf407fb60)
      0  CODE(0x7f9cf2e4d058)
         -> &Bio::SeqFeature::Generic::cleanup_generic
   '_source_tag' => 'tRNAscan-SE'




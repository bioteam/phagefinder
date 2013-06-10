#!/usr/bin/env perl

=head1 NAME

gff_to_biosql.pl

=head1 USAGE

Specify a sequence file (Genbank or Fasta) and one or more GFF3 files. For example:

./gff_to_biosql.pl -s NC_003197.gbk NC_003197_info.gff NC_003197_tab.gff NC_003197_tRNAscan.gff

or 

./gff_to_biosql.pl -s NC_003197.fa NC_003197_ptt.gff NC_003197_tab.gff

=head1 NOTES

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

my ($verbose,$seq_file);
my ( $db_name, $host, $driver, $user, $pass ) =
  qw(biosql localhost mysql root 123456);
my $namespace = 'Phage Database';
my $dsn = "DBI:$driver:database=$db_name;host=$host";

GetOptions( "s=s" => \$seq_file, "v" => \$verbose );

die "No sequence file specified with -s" if ( ! $seq_file );
die "No GFF files specified"   if ! @ARGV;

my $db = Bio::DB::BioDB->new(
    -database => 'biosql',
    -host     => $host,
    -dbname   => $db_name,
    -driver   => $driver,
    -user     => $user,
    -pass     => $pass,
    -dsn      => $dsn,
);

my $seq_io = Bio::SeqIO->new( -file => $seq_file );
my $seq = $seq_io->next_seq;
$seq->namespace($namespace);
print "Parsed $seq_file\n" if $verbose;

for my $gff_file (@ARGV) {
    my $gff_io = Bio::Tools::GFF->new( -file => $gff_file, -gff_version => 3 );

    while ( my $feature = $gff_io->next_feature() ) {
        $seq->add_SeqFeature($feature);
    }
	$gff_io->close();
	print "Parsed $gff_file\n" if $verbose;
}

my $adp  = $db->get_object_adaptor($seq);
my $pseq = $db->create_persistent($seq);
$pseq->store;
$adp->commit;
print "Loaded ",$seq->display_id,"\n" if $verbose;

__END__

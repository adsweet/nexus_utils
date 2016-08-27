#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin); 
use lib "$Bin/Text-CSV/lib";

use Text::CSV_PP;
use Data::Dumper;

# Given a filename returns the contents of that file
sub slurp_file {
    my $file = shift;
    my $output = do {
        open my $fh, '<', $file or die "Couldn't open $file: $!\n";
        <$fh>;
    };
    chomp($output);
    return $output;
}

die "Usage: $0 host.tre parasite.tre matrix.csv\n" unless scalar(@ARGV) == 3;

print "#NEXUS\n";
print "BEGIN HOST;\n";

my $host_tree = slurp_file($ARGV[0]);
$host_tree =~ s/1\.00000000//g;
$host_tree =~ s/\d+\.\d{5,}//g;
$host_tree =~ s/://g;

print "\tTREE * Host1 = $host_tree\n";
print "ENDBLOCK;\n\n";

print "BEGIN PARASITE\n";
my $parasite_tree = slurp_file($ARGV[1]);
$parasite_tree =~ s/1\.00000000//g;
$parasite_tree =~ s/\d+\.\d{5,}//g;
$parasite_tree =~ s/://g;
print "\tTREE * Para1 = $parasite_tree\n";
print "ENDBLOCK;\n\n";

print "BEGIN DISTRIBUTION;\n";
print "\tRANGE\n";

my $mapping = `$Bin/csv2tanglegram.pl $ARGV[2]`;
for my $line (split(/\n/, $mapping)) {
	chomp($line);
	print "\t\t$line\n";
}

print "\t;\n";
print "END;";


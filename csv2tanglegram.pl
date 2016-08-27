#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin); 
use lib "$Bin/Text-CSV/lib";

use Text::CSV_PP;
use Data::Dumper;

# inspect @ARGV
# print Dumper(\@ARGV);

# open the file

die "Usage: $0 matrix.csv\n" unless scalar(@ARGV) == 1;

my $file = $ARGV[0];

open my $fh, "<", $file or die "Couldn't open $file: $!\n";

# read csv
my $csv = Text::CSV_PP->new({ binary => 1, allow_whitespace => 1 });

my $first_row = 1;
my @parasite_names;
my @output;

# for each row
while (my $row = $csv->getline ($fh)) {
    my @fields = @$row;
    # strip out any whitespace
    if($first_row == 1) {
        # handle first row -- parasite names
	# first value of first row is always blank
	shift @fields;
	@parasite_names = @fields;
        $first_row = 0;
    } else {
        # handle normal rows -- host name + 0/1 if associated with parasite
	my $host_name = shift @fields;
	for my $i (0..scalar(@parasite_names)) {
            my $field = $fields[$i];
	    if($field and $field == 1) {
                push @output, "$parasite_names[$i]: $host_name";
	    }
	}

    }
}

print(join(",\n", @output));

close $fh;

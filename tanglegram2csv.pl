#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin); 
use lib "$Bin/Text-CSV/lib";

use Text::CSV_PP;
use List::Util qw(any);

# open the file

die "Usage: $0 matrix.csv\n" unless scalar(@ARGV) == 1;

my $file = $ARGV[0];

open my $fh, "<", $file or die "Couldn't open $file: $!\n";

my %parasite_host_combinations;
my %all_host_names;

# read each line
while (my $line = <$fh>) {
    if ($line =~ m/([^:]+): ([^,]+),/) {
        my $parasite  = $1;
	my $host_name = $2;
	$all_host_names{$host_name} = 1;
	my $hosts = $parasite_host_combinations{$parasite}; 
	if (ref $hosts eq 'ARRAY') {
            push @{$parasite_host_combinations{$parasite}}, $host_name;
	} else {
            $parasite_host_combinations{$parasite} = [$host_name];
	}
    }
}

my @parasites = keys %parasite_host_combinations;
my @hosts = keys %all_host_names;
# print first row
print(join(", ", (" ", @parasites)), "\n");
#print the rest
for my $host(@hosts) {
    my @output = ($host);

    for my $parasite(@parasites) {
        my $seen_hosts = $parasite_host_combinations{$parasite};
	if (any { $_ eq $host } @$seen_hosts) {
            push @output, 1;
	} else {
            push @output, 0;
	}
    }

    print(join(", ", @output), "\n");
}

close $fh;

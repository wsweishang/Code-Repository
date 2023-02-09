#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
my $input_path = $ARGV[0];
open (OUT, ">$ARGV[1]") or die "$!";

$input_path =~ /(.*)_\d+\.([^\.]+)$/;
my @files_path = glob "$1_*.$2";
foreach my $path (@files_path) {
	open (TXT, "<$path") or die "$!";
	print "$path\n";
	while (<TXT>) {
		print OUT "$_";
	}
}
close (TXT);
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
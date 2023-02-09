#!/usr/bin/perl

use strict;
use warnings;

open (INA, "<$ARGV[0]") or die "$!";
#open (INB, "<$ARGV[1]") or die "$!";
open (OUT, "<$ARGV[2]") or die "$!";
my $top_n = $ARGV[3];

my %a_data = ();
while (<INA>) {
	chomp (my $a_data = $_);
	next if ($a_data !~ /^LG.*/);
	my @a_data = split (/\t/, $a_data);
	if ($a_data[4] < 0) {
		$a_data[4] = 0 - $a_data[4];
	}
	$a_data{$a_data[0]}{$a_data[1]}{$a_data[2]} = $a_data[4];
}
close (INA);






#close (INB);
close (OUT);
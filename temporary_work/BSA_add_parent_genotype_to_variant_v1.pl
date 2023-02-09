#!/usr/bin/perl

use strict;
use warnings;

open (INTABLE, "<$ARGV[0]") or die "$!";
open (INVARIANT, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";
my @parent_index = split (/\t/, $ARGV[3]);

my (%vcf) = ();
while (<INTABLE>) {
	chomp (my $data = $_);
	my @data = split (/\t/, $data);
	$vcf{$data[0]}{$data[1]} = join ("\t", map {$data[$_]} @parent_index);
}
close (INTABLE);

while (<INVARIANT>) {
	chomp (my $data = $_);
	my @data = split (/\t/, $data);
	if (exists $vcf{$data[0]}{$data[1]}) {
		splice (@data, $parent_index[0], 0, $vcf{$data[0]}{$data[1]});
		print OUT join ("\t", @data), "\n";
	}
}
close (INVARIANT);
close (OUT);















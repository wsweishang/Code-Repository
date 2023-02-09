#!/usr/bin/perl

use strict;
use warnings;

open (INGFF,"<$ARGV[0]") or die "$!";
open (OUT,">$ARGV[1]") or die "$!";

while (<INGFF>) {
	chomp (my $gff_data = $_);
	my @gff_data = split (/\t/,$gff_data);
	if ($gff_data[2] eq "mRNA") {
		my @attributes = split (/[\=\;]/,$gff_data[8]);
		print OUT "$attributes[5]\t$gff_data[0]\t$gff_data[3]\t$gff_data[4]\t$gff_data[6]\n";
	}
	
}
close (INGFF);
close (OUT);


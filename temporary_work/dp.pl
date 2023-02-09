#!/usr/bin/perl

use strict;
use warnings;

open (INVCF, "<D:/6_CH_merged.raw.vcf.filtered.snp") or die "$!";
open (OUT, ">D:/6_CH.txt") or die "$!";

while (<INVCF>) {
	chomp (my $vcf_data = $_);
	next if ($vcf_data =~ /^#.*/);
	my @vcf_data = split (/\t/, $vcf_data);
	my $dp = ();
	for (my $i = 9 ; $i<= 14; $i++) {
		my @fmt = split (/:/, $vcf_data[$i]);
		if ($fmt[-2] eq ".") {
			next;
		} else {
			$dp += $fmt[-2];
		}
	}
	print OUT "$vcf_data[0]\t$vcf_data[1]\t$dp\n";
}
close (INVCF);
close (OUT);










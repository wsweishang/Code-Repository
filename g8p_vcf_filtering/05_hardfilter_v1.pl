#!/usr/bin/perl

use strict;
use warnings;

open (INVCF, "<$ARGV[0]") or die "$!";
open (AVCF, ">$ARGV[1]") or die "$!";
open (BVCF, ">$ARGV[2]") or die "$!";
my $proportion = $ARGV[3];

while (<INVCF>) {
	chomp (my $vcf_data = $_);
	next if ($vcf_data =~ /^#.*/);
	my @vcf_data = split (/\t/, $vcf_data);
	next if ($vcf_data[4] =~ /.*,.*/);
	my $count = ();
	for (my $i = 9 ; $i <= 88 ; $i++) {
		if ($vcf_data[$i] =~ /^0\/1.*/) {
			$count++;
		} elsif ($vcf_data[$i] =~ /^1\/1.*/) {
			$count++;
			$count++;
		} else {
			next;
		}
	}
	my $actual_proportion = $count / 160;
	if ($actual_proportion >= $proportion) {
		print AVCF "$vcf_data\n";
	} else {
		print BVCF "$vcf_data\n";
	}
}
close (INVCF);
close (AVCF);
close (BVCF);



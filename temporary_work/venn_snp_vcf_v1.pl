#!/usr/bin/perl

use strict;
use warnings;

open (INVCF, "<D:/SLAF_combined_filtered_hard_snp.vcf") or die "$!";
open (OUT, ">D:/SLAF_combined_filtered_hard_snp.matrix") or die "$!";

my @header = ();
my %gt = ();
my @count = ();
while (<INVCF>) {
	chomp (my $vcf_data = $_);
	next if ($vcf_data =~ /^##.*/);
	my @vcf_data = split (/\t/, $vcf_data);
	if ($vcf_data =~ /^#.*/) {
		@header = @vcf_data;
		print OUT join ("\t", @header[9..$#header]) , "\n";
		next;
	}
	for (my $i = 9 ; $i <= $#header ; $i++) {
		my $a_gt = substr ($vcf_data[$i], 0, 1);
		my $b_gt = substr ($vcf_data[$i], 2, 1);
		if ($a_gt eq "1" || $b_gt eq "1") {
			push (@{$gt{$header[$i]}}, "$vcf_data[0]_$vcf_data[1]");
			$count[$i]++;
		}
	}
}
close (INVCF);
@count = sort @count;

for (my $i = 1; $i <= $count[-1] ; $i++) {
	print OUT "$i";
	foreach my $sample (@header[9..$#header]) {
		my $gt = shift @{$gt{$sample}};
		if ($gt) {
			print OUT "\t$gt";
		} else {
			print OUT "\t";
		}
	}
	print OUT "\n";
}
close (OUT);



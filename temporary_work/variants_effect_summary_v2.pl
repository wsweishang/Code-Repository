#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;

open (FILEPATH, "<D:/research work/Grass_carp/Gene/workshop_filepath_list.txt") or die "$!";
open (SNPEFF, "<D:/research work/Grass_carp/Gene/Reseq_indiv_combined_filtered_snp_hard_snpEff.genes.txt") or die "$!";
open (SNPEFF, "<D:/research work/Grass_carp/Gene/Reseq_indiv_combined_filtered_snp_hard_snpEff.genes.txt") or die "$!";
open (OUT, ">D:/research work/Grass_carp/Gene/t.txt") or die "$!";

my (@order, %ortholog, %gene) = ();
while (<FILEPATH>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my @txt = split (/\t/, $txt);
	push (@order, $txt[0]);
	open (GENE, "<$txt[2]") or die "$!";
	while (<GENE>) {
		chomp (my $gene = $_);
		next if ($gene =~ /^#.*/);
		my @gene = split (/\t/, $gene);
		$gene{$gene[0]}{"k_number"} = $gene[1];
		$gene{$gene[0]}{$txt[0]} = 1;
	}
	close (GENE);
}
close (FILEPATH);

my %snpeff = ();
while (<SNPEFF>) {
	chomp (my $snpeff = $_);
	next if ($snpeff =~ /^#.*/);
	my @snpeff = split (/\t/, $snpeff);
	if ($snpeff[4] > 0) {
		$snpeff{$snpeff[0]} = join (".", @snpeff[4..21]);
	}
}
close (SNPEFF);

foreach my $gene (sort {$a cmp $b} keys %gene) {
	next unless (exists $snpeff{$gene});
	print OUT "$gene\t$gene{$gene}{'k_number'}\t$snpeff{$gene}";
	foreach my $order (@order) {
		if (exists $gene{$gene}{$order}) {
			print OUT "\t$order";
		} else {
			print OUT "\t";
		}
	}
	print OUT "\n";
}
close (OUT);























































printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (GENE, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/input.txt") or die "$!";
open (FPKM, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_TA_brain_vs_TU_brain_with24.txt") or die "$!";
open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/output.txt") or die "$!";
####################################################################################################
my (@gene, %gene) = ();
while (<GENE>) {
	chomp (my $gene = $_);
	next if ($gene =~ /^#.*/);
	$gene{$gene} = 1;
	push (@gene, $gene);
}
close (GENE);
####################################################################################################
my (@sample_order, %fpkm) = ();
while (<FPKM>) {
	chomp (my $fpkm = $_);
	my @fpkm = split (/\t/, $fpkm);
	my ($gene_name, $description) = splice (@fpkm, 0, 2);
	if ($fpkm =~ /^NAME.*/) {
		@sample_order = @fpkm;
		next;
	}
	next unless ($gene{$gene_name});
	map {push (@{$fpkm{$gene_name}}, $_)} @fpkm;
}
close (FPKM);
####################################################################################################
print OUT "NAME\t", join ("\t", @sample_order), "\n";
foreach my $gene_name (@gene) {
	my @gene_fpkm = @{$fpkm{$gene_name}};
	my @sort_fpkm = sort {$a <=> $b} @gene_fpkm;
	my $min = $sort_fpkm[0];
	my $max = $sort_fpkm[-1];
	my $scale = ($max - $min) / 9;
	my @scale = map {(int (($_ - $min) / $scale)) + 1} @gene_fpkm;
	print OUT "$gene_name\t", join ("\t", @scale), "\n";
}
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (GENESEQ, "<D:/research work/WGCNA/data/Nile_tilapia_gene_pep.fa") or die "$!";
open (GENELIST, "<D:/research work/WGCNA/NTGonadTPM/phenotype_Weight_module_lightgreen_gene_summary.txt") or die "$!";
open (OUT, ">D:/research work/WGCNA/NTGonadTPM/phenotype_Weight_module_lightgreen_gene_seq_pep.fa") or die "$!";
####################################################################################################
my ($gene_id, %gene_seq) = ();
while (<GENESEQ>) {
	chomp (my $data = $_);
	if ($data =~ /^>(\S+).*/) {
		$gene_id = $1;
	} else {
		$gene_seq{$gene_id} .= $data;
	}
}
close (GENESEQ);
####################################################################################################
while (<GENELIST>) {
	chomp (my $data = $_);
	next if ($data =~ /^Gene.*/);
	my ($gene_name) = (split (/\t/, $data))[0];
#	$gene_name = substr ($gene_name, 2);
	$gene_name =~ tr/_/./;
	if ($gene_seq{$gene_name}) {
		print OUT ">$gene_name\n";
		print OUT "$gene_seq{$gene_name}\n";
	} else {
		print STDERR "gene [$gene_name] not found\n";
	}
}
close (GENELIST);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
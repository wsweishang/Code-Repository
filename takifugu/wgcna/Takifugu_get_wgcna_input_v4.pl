#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (FPKMLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_4/Takifugu_rubripes_wgcna_cuffnorm_fpkm_pathlist.txt") or die "$!";
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_4";
####################################################################################################
while (<FPKMLIST>) {
	chomp (my $fpkmlist = $_);
	next if ($fpkmlist =~ /^#.*/);
	my @fpkmlist = split (/\t/, $fpkmlist);
	my ($output_filename, $input_genelist_path) = splice (@fpkmlist, 0, 2);
	open (GENELIST, "<$input_genelist_path") or die "$!";
	
	
	
	my (%genelist) = ();
	while (<GENELIST>) {
		chomp (my $genelist = $_);
		next if ($genelist =~ /^#.*/);
		my @genelist = split (/\t/, $genelist);
		next if ($genelist[1] =~ /^si:.*/);
		next if ($genelist[1] =~ /^zgc:.*/);
		next if ($genelist[1] =~ /^U4.*/);
		next if ($genelist[1] =~ /^Vault.*/);
		next if ($genelist[1] =~ /^5S_rRNA.*/);
		$genelist{$genelist[0]} = uc ($genelist[1]);
	}
	close (GENELIST);
	
	my $output_gct_path = $output_dir . "/$output_filename" . "/Takifugu_rubripes_wgcna_input_fpkm.txt";
	open (OUTGCT, ">$output_gct_path") or die "$!";
	
	my (@gct_order, @cls_order, %gene_fpkm) = ();
	foreach my $input_fpkm_path (@fpkmlist) {
		my (@header) = ();
		open (INFPKM, "<$input_fpkm_path") or die "$!";
		while (<INFPKM>) {
			chomp (my $gene_fpkm = $_);
			my @gene_fpkm = split (/\t/, $gene_fpkm);
			if ($gene_fpkm =~ /^tracking_id.*/) {
				@header = map {substr ($gene_fpkm[$_], 0, -2)} 0..$#gene_fpkm;
				push (@gct_order, map {substr ($gene_fpkm[$_], 0, -2)} 1..$#gene_fpkm);
				push (@cls_order, map {substr ($gene_fpkm[$_], 0, -7)} 1..$#gene_fpkm);
				next;
			}
			next unless ($genelist{$gene_fpkm[0]});
			map {$gene_fpkm{$genelist{$gene_fpkm[0]}}{$header[$_]} = $gene_fpkm[$_]} 1..$#gene_fpkm;
#			map {$gene_fpkm{$gene_fpkm[0]}{$header[$_]} = $gene_fpkm[$_]} 1..$#gene_fpkm;
		}
		close (INFPKM);
	}
	
	print OUTGCT "Gene\t", join ("\t", @gct_order), "\n";
	foreach my $gene_id (sort {$a cmp $b} keys %gene_fpkm) {
		print OUTGCT "$gene_id";
		foreach my $gct_order (@gct_order) {
			print OUTGCT "\t$gene_fpkm{$gene_id}{$gct_order}";
		}
		print OUTGCT "\n";
	}
	close (OUTGCT);
}
close (FPKMLIST);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
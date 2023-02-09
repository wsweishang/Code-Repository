#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (GENELIST, "<D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_3/TATU_updown/Takifugu_rubripes_TA_vs_TU_DEG_gene_id.txt") or die "$!";
open (FPKMLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_3/TATU_updown/Takifugu_rubripes_wgcna_cuffnorm_fpkm_pathlist.txt") or die "$!";
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_3/TATU_updown";
####################################################################################################
##Reading Gene id and Gene name comparison table.
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
####################################################################################################
##Reading FPKM path list.
while (<FPKMLIST>) {
	chomp (my $fpkmlist = $_);
	next if ($fpkmlist =~ /^#.*/);
	my @fpkmlist = split (/\t/, $fpkmlist);
	my $output_filename = splice (@fpkmlist, 0, 1);
	my $output_gct_path = $output_dir . "/Takifugu_rubripes_" . $output_filename . ".txt";
	my (@gct_order, @cls_order, %gene_fpkm) = ();
	foreach my $input_fpkm_path (@fpkmlist) {
		my (@header) = ();
##Reading FPKM files one by one.
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
		}
		close (INFPKM);
##Writing out GCT file.
		open (OUTGCT, ">$output_gct_path") or die "$!";
#		print OUTGCT "#1.2\n";
#		print OUTGCT scalar keys %gene_fpkm, "\t", scalar @gct_order, "\n";
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
}
close (FPKMLIST);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;

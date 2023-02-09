#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (FPKMLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/input/Takifugu_rubripes_fpkm_pathlist.txt") or die "$!";
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/input";
####################################################################################################
while (<FPKMLIST>) {
	chomp (my $fpkmlist = $_);
	next if ($fpkmlist =~ /^#.*/);
	my @fpkmlist = split (/\t/, $fpkmlist);
	my $output_filename = splice (@fpkmlist, 0, 1);
	my $output_gct_path = $output_dir . "/Takifugu_rubripes_" . $output_filename . ".gct";
	my $output_cls_path = $output_dir . "/Takifugu_rubripes_" . $output_filename . ".cls";
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
				push (@cls_order, map {substr ($gene_fpkm[$_], 0, -4)} 1..$#gene_fpkm);
				next;
			}
			map {$gene_fpkm{$gene_fpkm[0]}{$header[$_]} = $gene_fpkm[$_]} 1..$#gene_fpkm;
		}
		close (INFPKM);
		
		open (OUTGCT, ">$output_gct_path") or die "$!";
		print OUTGCT "#1.2\n";
		print OUTGCT scalar keys %gene_fpkm, "\t", scalar @gct_order, "\n";
		print OUTGCT "NAME\tDescription\t", join ("\t", @gct_order), "\n";
		foreach my $gene_id (sort {$a cmp $b} keys %gene_fpkm) {
			print OUTGCT "$gene_id\tna";
			foreach my $gct_order (@gct_order) {
				print OUTGCT "\t$gene_fpkm{$gene_id}{$gct_order}";
			}
			print OUTGCT "\n";
		}
		close (OUTGCT);
		
		open (OUTCLS, ">$output_cls_path") or die "$!";
		print OUTCLS scalar @gct_order, " 2 1\n";
		my %hash = ();
		print OUTCLS "#", join (" ", grep {++$hash{$_} < 2} @cls_order), "\n";
		print OUTCLS join (" ", @cls_order), "\n";
		close (OUTCLS);
	}
}
close (FPKMLIST);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
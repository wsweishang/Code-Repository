#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (GENELIST, "<D:/t_gene.txt") or die "$!";
open (FPKMLIST, "<D:/t_pathlist.txt") or die "$!";
my $output_dir = "D:/research work";
####################################################################################################
##Reading Gene id and Gene name comparison table.
my (%genelist) = ();
while (<GENELIST>) {
	chomp (my $genelist = $_);
	next if ($genelist =~ /^#.*/);
	my @genelist = split (/\t/, $genelist);
	next if ($genelist[5] =~ /^si:.*/);
	next if ($genelist[5] =~ /^zgc:.*/);
	next if ($genelist[5] =~ /^U4.*/);
	next if ($genelist[5] =~ /^Vault.*/);
	next if ($genelist[5] =~ /^5S_rRNA.*/);
	$genelist{$genelist[4]} = uc ($genelist[5]);
	
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
	my $output_cls_path = $output_dir . "/Takifugu_rubripes_" . $output_filename . ".cls";
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
		print OUTGCT "NAME\tDescription\t", join ("\t", @gct_order), "\n";
		foreach my $gene_id (sort {$a cmp $b} keys %gene_fpkm) {
			print OUTGCT "$gene_id\tna";
			foreach my $gct_order (@gct_order) {
				print OUTGCT "\t$gene_fpkm{$gene_id}{$gct_order}";
			}
			print OUTGCT "\n";
		}
		close (OUTGCT);
##Writing out CLS file.
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

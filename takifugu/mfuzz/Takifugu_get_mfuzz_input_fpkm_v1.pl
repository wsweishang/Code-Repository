#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (GENELIST, "<D:/research work/Takifugu/RNAseq/03.statistics/10.Mfuzz/Takifugu_rubripes_gene_id_comparison_table_v1.txt") or die "$!";
open (FPKMLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/10.Mfuzz/Takifugu_rubripes_fpkm_pathlist.txt") or die "$!";
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/10.Mfuzz";
####################################################################################################
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
	$genelist{$genelist[4]} = $genelist[5];
#	$genelist{$genelist[4]} = uc ($genelist[5]);
}
close (GENELIST);
####################################################################################################
while (<FPKMLIST>) {
	chomp (my $fpkmlist = $_);
	next if ($fpkmlist =~ /^#.*/);
	my @fpkmlist = split (/\t/, $fpkmlist);
	my $output_filename = splice (@fpkmlist, 0, 1);
	my $output_txt_path = $output_dir . "/Takifugu_rubripes_" . $output_filename . ".txt";
	my (@txt_order, %gene_fpkm) = ();
	foreach my $input_fpkm_path (@fpkmlist) {
		my (@header) = ();
		
		open (INFPKM, "<$input_fpkm_path") or die "$!";
		while (<INFPKM>) {
			chomp (my $gene_fpkm = $_);
			my @gene_fpkm = split (/\t/, $gene_fpkm);
			if ($gene_fpkm =~ /^tracking_id.*/) {
				@header = map {substr ($gene_fpkm[$_], 0, -4)} 0..$#gene_fpkm;
				push (@txt_order, map {substr ($gene_fpkm[$_], 0, -4)} 1..$#gene_fpkm);
				my %hash = ();
				@txt_order = grep {++$hash{$_} < 2} @txt_order;
				next;
			}
			next unless ($genelist{$gene_fpkm[0]});
			map {$gene_fpkm{$genelist{$gene_fpkm[0]}}{$header[$_]} += $gene_fpkm[$_]} 1..$#gene_fpkm;
		}
		close (INFPKM);
		
		open (OUTTXT, ">$output_txt_path") or die "$!";
		print OUTTXT "NAME\t", join ("\t", @txt_order), "\n";
		foreach my $gene_id (sort {$a cmp $b} keys %gene_fpkm) {
			print OUTTXT "$gene_id";
			foreach my $txt_order (@txt_order) {
				print OUTTXT "\t", $gene_fpkm{$gene_id}{$txt_order} / 3;
			}
			print OUTTXT "\n";
		}
		close (OUTTXT);
	}
}
close (FPKMLIST);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (TPMTABLE, "<D:/research work/WGCNA/新建文件夹/NTLiverTPM/NTLiverTPM_expression_input.txt") or die "$!";
my @gene_list_pathes = glob ("'D:/research work/WGCNA/新建文件夹/NTLiverTPM/*_gene_summary.txt'");
####################################################################################################
my ($header, %tpm_table) = ();
while (<TPMTABLE>) {
	chomp (my $data = $_);
	if ($data =~ /^Gene.*/) {
		$header = $data;
		next;
	} else {
		my ($gene_id) = (split (/\t/, $data))[0];
		$tpm_table{$gene_id} = $data;
	}
}
close (TPMTABLE);
####################################################################################################
foreach my $gene_list_path (@gene_list_pathes) {
	$gene_list_path =~ /(.*)\/(.*)_gene_summary.txt/;
	my ($file_path, $file_name) = ($1, $2);
	open (GENELIST, "<$gene_list_path") or die "$!";
	open (OUT, ">${file_path}/${file_name}_gene_tpm.txt") or die "$!";
	print OUT "$header\n";
	while (<GENELIST>) {
		chomp (my $data = $_);
		next if ($data =~ /^Gene.*/);
		my ($gene_name) = (split (/\t/, $data))[0];
		$gene_name =~ tr/_/./;
		if ($tpm_table{$gene_name}) {
			print OUT "$tpm_table{$gene_name}\n";
		} else {
			print STDERR "gene [$gene_name] not found\n";
		}
	}
	close (GENELIST);
	close (OUT);
}
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
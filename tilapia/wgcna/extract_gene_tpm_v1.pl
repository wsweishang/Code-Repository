#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (TPMTABLE, "<D:/research work/WGCNA/NTGonadTPM/NTGonadTPM_expression_input.txt") or die "$!";
open (GENELIST, "<D:/research work/WGCNA/NTGonadTPM/phenotype_Weight_module_lightgreen_gene_summary.txt") or die "$!";
open (OUT, ">D:/research work/WGCNA/NTGonadTPM/phenotype_Weight_module_lightgreen_gene_tpm.txt") or die "$!";
####################################################################################################
my %tpm_table = ();
while (<TPMTABLE>) {
	chomp (my $data = $_);
	if ($data =~ /^Gene.*/) {
		print OUT "$data\n";
		next;
	} else {
		my ($gene_id) = (split (/\t/, $data))[0];
		$tpm_table{$gene_id} = $data;
	}
}
close (TPMTABLE);
####################################################################################################
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
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
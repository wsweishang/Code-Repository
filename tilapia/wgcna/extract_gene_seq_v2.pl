#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (GENESEQ, "<D:/research work/WGCNA/data/Nile_tilapia_gene_pep.fa") or die "$!";
my @gene_list_pathes = glob ("'D:/research work/WGCNA/新建文件夹/NTLiverTPM/*_gene_summary.txt'");
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
foreach my $gene_list_path (@gene_list_pathes) {
	$gene_list_path =~ /(.*)\/(.*)_gene_summary.txt/;
	my ($file_path, $file_name) = ($1, $2);
	
	open (GENELIST, "<$gene_list_path") or die "$!";
	open (OUT, ">${file_path}/${file_name}_gene_seq_pep.fa") or die "$!";
	
	while (<GENELIST>) {
		chomp (my $data = $_);
		next if ($data =~ /^Gene.*/);
		my ($gene_name) = (split (/\t/, $data))[0];
#		$gene_name = substr ($gene_name, 2);
		$gene_name =~ tr/_/./;
		if ($gene_seq{$gene_name}) {
			print OUT ">$gene_name\n";
			print OUT "$gene_seq{$gene_name}\n";
		} else {
			print STDERR "gene [$gene_name] not found\n";
		}
	}
	close (GENELIST);
	close (OUT);
}
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;

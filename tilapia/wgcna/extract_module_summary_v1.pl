#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
my @gene_list_pathes = glob ("'D:/research work/WGCNA/新建文件夹/*/*_gene_summary.txt'");
my @cor_table_pathes = glob ("'D:/research work/WGCNA/新建文件夹/*/table_1.txt'");
open (OUT, ">D:/research work/WGCNA/新建文件夹/module_summary.txt") or die "$!";
#####################################################################################################
my (@header, %cor) = ();
foreach my $cor_table_path (@cor_table_pathes) {
	$cor_table_path =~ /.*\/([A-Z]{2})([a-zA-Z]+)TPM\/.*.txt/;
	my ($species, $organ) = ($1, $2);
	open (CORTABLE, "<$cor_table_path") or die "$!";
	while (<CORTABLE>) {
		chomp (my $data = $_);
		my @data = split (/\t/, $data);
		if ($data =~ /^module_name.*/) {
			@header = @data;
			next;
		}
		for (my $i = 1; $i <= $#data; $i++) {
			my $header = $header[$i];
			$header =~ /(.*)_(.*)/;
			$cor{"${species}_${organ}_phenotype_${2}_module_$data[0]"}{$1} = $data[$i];
		}
	}
	close (CORTABLE);
}

print OUT "#Module\tgene_num\tcorrelation\tp_value\torgan\tBT/NT\n";
foreach my $gene_list_path (@gene_list_pathes) {
	$gene_list_path =~ /.*\/([A-Z]{2})([a-zA-Z]+)TPM\/(.*)_gene_summary.txt/;
	my ($species, $organ, $module) = ($1, $2, $3);
	my $gh = "${species}_${organ}_${module}";
	open (GENELIST, "<$gene_list_path") or die "$!";
	my ($count) = ();
	while (<GENELIST>) {
		chomp (my $data = $_);
		next if ($data =~ /^Gene.*/);
		$count++;
	}
	print OUT "$module\t$count\t$cor{$gh}{'cor'}\t$cor{$gh}{'cor_p'}\t$organ\t$species\n";
	close (GENELIST);
}
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
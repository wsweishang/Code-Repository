#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/";
my $pathway = "Apoptosis";
####################################################################################################
while (<DATA>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my ($organ, $gene_expression_path, $target_gene_path) = split (/\t/, $data);
	my (@header, %order, %deg) = ();
	open (INDEG, "<${gene_expression_path}") or die "$!";
	while (<INDEG>) {
		chomp (my $data = $_);
		if ($data =~ /^#(.*)/) {
			my @data = split (/\t/, $1);
			@header = map {$data[$_]} (0, 1, map {$_ * 5 - 1, $_ * 5 + 1} 1..6);
			next;
		}
		my @data = split (/\t/, $data);
		$deg{$data[1]}{$data[0]} = join ("\t", map {$data[$_]} (map {$_ * 5 - 1, $_ * 5 + 1} 1..6));
		$order{$data[1]} = 1;
	}
	close (INDEG);
	
	open (INGENELIST, "<${target_gene_path}") or die "$!";
	open (OUT, ">${output_dir}Fugu_DEG_heatmap_${pathway}_${organ}.txt") or die "$!";
	print OUT join("\t", @header), "\n";
	while (<INGENELIST>) {
		chomp (my $data = $_);
		next if ($data =~ /^#.*/);
		my $gene_name = (split (/\t/, $data))[0];
#		$gene_name = $1 if ($gene_name =~ /^([a-zA-Z_]+[0-9]{0,1}).*\.*/);
#		foreach my $order (sort {$a cmp $b} keys %order) {
#			if ($order =~ /^$gene_name/) {
#				foreach my $gene_id (sort {$a cmp $b} keys %{$deg{$order}}) {
#					print OUT "$gene_id\t${order}_$gene_name\t$deg{$order}{$gene_id}\n";
#				}
#			}
#		}
		my ($left, $right) = split (/_/, $gene_name);
		$right = $left unless ($right);
		foreach my $order (sort {$a cmp $b} keys %order) {
			if ($order eq $left) {
				foreach my $gene_id (sort {$a cmp $b} keys %{$deg{$order}}) {
					print OUT "$gene_id\t${order}_$right\t$deg{$order}{$gene_id}\n";
				}
			}
		}
	}
	close (OUT);
}
close (DATA);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
__DATA__
#Organ	gene_expression_path_list	target_gene_set_path_list
Brain	D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/Fugu_DEG_cuffdiff_Brain.txt	D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/apoptosis_genes_in_zebrafish_brain_v1.txt
Gill	D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/Fugu_DEG_cuffdiff_Gill.txt	D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/apoptosis_genes_in_zebrafish_gill_v1.txt
Int	D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/Fugu_DEG_cuffdiff_Int.txt	D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/apoptosis_genes_in_zebrafish_int_v1.txt
Liver	D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/Fugu_DEG_cuffdiff_Liver.txt	D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/apoptosis_genes_in_zebrafish_liver_v1.txt
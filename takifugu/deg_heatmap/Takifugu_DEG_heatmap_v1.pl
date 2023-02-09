#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (INGENELIST, "<D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/apoptosis_genes_in_zebrafish_v4.txt") or die "$!";
my @deg_pathes = glob ("'D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/*/gene_exp.diff'");
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/";
####################################################################################################
my (%gene_list) = ();
while (<INGENELIST>) {
	chomp (my $data = $_);
	next if ($data =~ /^SUID.*/);
	my @data = split (/\t/, $data);
	if ($data[1] eq "gene") {
		if ($data[0] =~ /^([a-zA-Z_]+[0-9]{0,1}).*\.*/) {
			my $gene_name = $1;
#			my $gene_name = $data[0];
			$gene_list{$data[0]} = $gene_name;
		}
	}
}
close (INGENELIST);

#print Dumper (\%gene_list) and die;

my (%deg_gene) = ();
foreach my $deg_path (@deg_pathes) {
	$deg_path =~ /.*\/(.*)_(.*)_(.*)_vs_.*\/gene_exp.diff/;
	my ($population, $organ, $temprature) = ($1, $2, $3);
	open (INDEG, "<$deg_path") or die "$!";
	while (<INDEG>) {
		chomp (my $data = $_);
		next if ($data =~ /^test_id.*/);
		my @data = split (/\t/, $data);
		foreach my $gene_name (sort {$a cmp $b} keys %gene_list) {
			if ($data[2] =~ /^$gene_list{$gene_name}/) {
				my $fold_change = $data[9];
				if ($data[9] =~ /.*inf.*/) {
					my $value_1 = ($data[7] == 0) ? 0.1 : $data[7];
					my $value_2 = ($data[8] == 0) ? 0.1 : $data[8];
					$fold_change = log($value_2 / $value_1) / log(2);
				}
				$deg_gene{$organ}{"$data[0]\t$data[2]\t$gene_name"}{$population}{$temprature} = "$fold_change\t$data[12]";
			}
		}
	}
	close (INDEG);
}

foreach my $organ (sort {$a cmp $b} keys %deg_gene) {
	my $output_path = $output_dir."Fugu_DEG_heatmap_".ucfirst($organ)."_Apoptosis.txt";
	open (OUT, ">$output_path") or die "$!";
	print OUT "gene_id\tgene_name_in_cuffdiff\tgene_name_in_kegg\tTA_04\tTA_04_fdr\tTA_07\tTA_07_fdr\tTA_16\tTA_16_fdr\tTU_04\tTU_04_fdr\tTU_07\tTU_07_fdr\tTU_16\tTU_16_fdr\n";
	foreach my $gene_name (sort {$a cmp $b} keys %{$deg_gene{$organ}}) {
		print OUT "$gene_name";
		foreach my $population (sort {$a cmp $b} keys %{$deg_gene{$organ}{$gene_name}}) {
			foreach my $temprature (sort {$a cmp $b} keys %{$deg_gene{$organ}{$gene_name}{$population}}) {
				print OUT "\t$deg_gene{$organ}{$gene_name}{$population}{$temprature}";
			}
		}
		print OUT "\n";
	}
}
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (GENELIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gene_id_comparison_table_v2.txt") or die "$!";
open (PATHLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/04.Shared_gene/diffOrgan_p005_04_07_16_vs_24/Takifugu_rubripes_venn_deg_share_pathlist.txt") or die "$!";
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/04.Shared_gene/diffOrgan_p005_04_07_16_vs_24";
#####################################################################################################
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
#####################################################################################################
while (<PATHLIST>) {
	chomp (my $pathlist = $_);
	next if ($pathlist =~ /^#.*/);
	my ($tempreature, $organ, $input_deg_path) = (split (/\t/, $pathlist))[0..2];
	my $output_filename = $tempreature . "_" . $organ . "_deg_venn_input_p005.txt";
	my $output_venn_path = $output_dir . "/" . $output_filename;
	open (INDEG, "<$input_deg_path") or die "$!";
	open (OUTVENN, ">$output_venn_path") or die "$!";
	while (<INDEG>) {
		chomp (my $deg = $_);
		next if ($deg =~ /^test_id.*/);
		my @deg = split (/\t/, $deg);
		next unless ($genelist{$deg[0]});
		if ($deg[11] <= 0.05) {
			print OUTVENN "$deg[0]\n";
		}		
	}
	close (INDEG);
	close (OUTVENN);
}
close (PATHLIST);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (GENELIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gene_id_comparison_table_v2.txt") or die "$!";
open (PATHLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/04.Shared_gene/diffOrgan_q005_04_07_16_vs_24/Takifugu_rubripes_venn_deg_share_pathlist.txt") or die "$!";
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/04.Shared_gene/diffOrgan_q005_04_07_16_vs_24";
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
	my $output_up_path = $output_dir . "/" . $tempreature . "_" . $organ . "_deg_venn_input_p005_up.txt";
	my $output_down_path = $output_dir . "/" . $tempreature . "_" . $organ . "_deg_venn_input_p005_down.txt";
	open (INDEG, "<$input_deg_path") or die "$!";
	open (OUTUP, ">$output_up_path") or die "$!";
	open (OUTDOWN, ">$output_down_path") or die "$!";
	while (<INDEG>) {
		chomp (my $deg = $_);
		next if ($deg =~ /^test_id.*/);
		my @deg = split (/\t/, $deg);
		next unless ($genelist{$deg[0]});
		if ($deg[12] <= 0.05) {
			if ($deg[9] >= 0) {
				print OUTUP "$deg[0]\n";
			} else {
				print OUTDOWN "$deg[0]\n";
			}
		}		
	}
	close (INDEG);
	close (OUTUP);
	close (OUTDOWN);
}
close (PATHLIST);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
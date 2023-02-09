#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (PATHLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gsea_ridgeplot_pathlist.txt") or die "$!";
open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/ridgeplot/Takifugu_rubripes_gsea_ridgeplot_ggplot2_input.txt") or die "$!";
####################################################################################################
my ($i) = ();
print OUT "Num\tName\tFoldchange\n";
while (<PATHLIST>) {
	chomp (my $pathlist = $_);
	next if ($pathlist =~ /^#.*/);
	my @pathlist = split (/\t/, $pathlist);
	my $name = $pathlist[0];
	my (%target_gene_name) = ();
	open (INTSV, "<$pathlist[2]") or die "$!";
	while (<INTSV>) {
		chomp (my $tsv = $_);
		next if ($tsv =~ /^NAME.*/);
		my @tsv = split (/\t/, $tsv);
		$target_gene_name{$tsv[1]} = 1 if ($tsv[6] eq "Yes");
	}
	close (INTSV);
	
	$i++;
	my ($length) = ();
	open (INGCT, "<$pathlist[1]") or die "$!";
	while (<INGCT>) {
		chomp (my $gct = $_);
		my @gct = split (/\t/, $gct);
		if ($. <= 3) {
			$length = $gct[1] if ($. == 2);
			next;
		}
		next unless ($target_gene_name{$gct[0]});
		
		my ($group_1, $group_2) = ();
		map {$group_1 += $gct[$_]} 2..($length / 2 + 1);
		map {$group_2 += $gct[$_]} ($length / 2 + 2)..($length + 1);
		$group_1 = $group_1 / ($length / 2) + 0.01;
		$group_2 = $group_2 / ($length / 2) + 0.01;
		my $fold_change = (log ($group_2 / $group_1)) / (log (2));
		print OUT "$i\t$name\t$fold_change\n";
	}
	close (INGCT);
}
close (PATHLIST);
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
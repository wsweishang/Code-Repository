#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (PATHLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gsea_pathlist.txt") or die "$!";
open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_TA_brain_vs_TU_brain_with24.txt") or die "$!";
####################################################################################################
my ($i) = ();
while (<PATHLIST>) {
	chomp (my $pathlist = $_);
	next if ($pathlist =~ /^#.*/);
	my @pathlist = split (/\t/, $pathlist);
	my $name = $pathlist[0];
	my ($length, @group_1, @group_2) = ();
	$i++;
	open (IN, "<$pathlist[1]") or die "$!";
	while (<IN>) {
		chomp (my $data = $_);
		next if ($. == 1);
		next if ($. == 3);
		my @data = split (/\t/, $data);
		if ($. == 2) {
			$length = $data[1];
			@group_1 = 2..($data[1] / 2 + 1);
			@group_2 = ($data[1] / 2 + 2)..($data[1] + 1);
			next;
		}
		my ($group_1, $group_2) = ();
		map {$group_1 += $data[$_]} @group_1;
		map {$group_2 += $data[$_]} @group_2;
		$group_1 = $group_1 / ($length / 2);
		$group_2 = $group_2 / ($length / 2);
		next if ($group_1 == 0);
		next if ($group_2 == 0);
		my $fold_change = (log ($group_2 / $group_1)) / (log (2));
#		my $fold_change = $group_2 / $group_1;
		print OUT "$i\t$name\t$fold_change\n";
	}
	close (IN);
}
close (PATHLIST);
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
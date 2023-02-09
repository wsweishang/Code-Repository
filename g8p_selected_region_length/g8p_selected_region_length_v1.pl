#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Statistics::Descriptive;
use Statistics::Robust::Scale qw(MAD);
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (INMATRIX, "<D:/research work/Grass_carp/Resequence/matrix/WZ_vs_TJ_reseq_50kb_2kb_top005.matrix") or die "$!";

my %region = ();
while (<INMATRIX>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	$region{$data[0]}{$data[1]} = $data[2];
}
close (INMATRIX);

my $total_region_length_sum = ();
foreach my $chr (sort {$a cmp $b} keys %region) {
	my @start = sort {$a <=> $b} keys %{$region{$chr}};
	my (@region_start, @region_t, @region_end) = ();
	unshift (@start, -3000);
	for (my $i = 1; $i <= $#start; $i++) {
		my $step = $start[$i] - $start[$i - 1];
		if ($step != 2000) {
			push (@region_start, $start[$i]);
			push (@region_t, $start[$i - 1]);
		}
	}
	shift @region_t;
	push (@region_t, $start[$#start]);
	map {push (@region_end, $region{$chr}{$_})} @region_t;
	my $region_length_sum = ();
	
	for (my $p = 0; $p <= $#region_start; $p++) {
		my $region_length = $region_end[$p] - $region_start[$p];
		$region_length_sum += $region_length;
		$total_region_length_sum += $region_length;
	}
	print "$chr\t$region_length_sum\n";
}
print "$total_region_length_sum\n";

#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
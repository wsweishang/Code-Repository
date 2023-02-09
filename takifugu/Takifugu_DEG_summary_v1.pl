#!/usr/bin/perl

use strict;
use warnings;
use Statistics::Descriptive;
#use Statistics::Basic qw(:all);
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
my @deg_pathes = glob ("'D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/*/gene_exp.diff'");
open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/08.deg_summary/Fugu_DEG_summary_fdr001.txt") or die "$!";
####################################################################################################
my (%deg) = ();
foreach my $deg_path (@deg_pathes) {
	$deg_path =~ /.*\/(.*)_(.*)_(.*)_vs_.*\/gene_exp.diff/;
	my ($population, $organ, $temprature) = ($1, $2, $3);
	open (IN, "<$deg_path") or die "$!";
	while (<IN>) {
		chomp (my $data = $_);
		next if ($data =~ /^test_id.*/);
		my @data = split (/\t/, $data);
		if ($data[12] <= 0.01) {
			my $diff = $data[8] - $data[7];
			if ($diff > 0) {
				push (@{$deg{$population}{$organ}{$temprature}{"up"}}, $diff);
			} else {
				push (@{$deg{$population}{$organ}{$temprature}{"down"}}, $diff);
			}
		}
	}
	close (IN);
}

#print OUT "#population\torgan\ttemprature\tupdown\tnumber\tmean\ttrimmed_mean\tvariance\tstandard_deviation\t";
#print OUT "median\tquantile_zero\tquantile_first\tquantile_second\tquantile_third\tquantile_fourth\n";
print OUT "population\torgan\ttemprature\tupdown\tnumber\n";
foreach my $population (sort {$a cmp $b} keys %deg) {
	foreach my $organ (sort {$a cmp $b} keys %{$deg{$population}}) {
		foreach my $temprature (sort {$a cmp $b} keys %{$deg{$population}{$organ}}) {
			foreach my $updown (sort {$a cmp $b} keys %{$deg{$population}{$organ}{$temprature}}) {
				print OUT "$population\t$organ\t$temprature\t$updown\t";
				print OUT scalar @{$deg{$population}{$organ}{$temprature}{$updown}}, "\n";
#				$Statistics::Descriptive::Tolerance = 1e-10;
#				my $stat = Statistics::Descriptive::Full -> new();
#				$stat -> add_data(@{$deg{$population}{$organ}{$temprature}{$updown}});
#				print OUT $stat -> count(), "\t";
#				print OUT $stat -> mean(), "\t";
#				print OUT $stat -> trimmed_mean(0.1, 0.1), "\t";
#				print OUT $stat -> variance(), "\t";
#				print OUT $stat -> standard_deviation(), "\t";
#				print OUT $stat -> median(), "\t";
#				print OUT $stat -> quantile(0), "\t";
#				print OUT $stat -> quantile(1), "\t";
#				print OUT $stat -> quantile(2), "\t";
#				print OUT $stat -> quantile(3), "\t";
#				print OUT $stat -> quantile(4), "\n";
			}
		}
	}
}
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
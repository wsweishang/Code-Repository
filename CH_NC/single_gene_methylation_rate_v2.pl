#!/usr/bin/perl

use strict;
use warnings;

open (INGFF,"<E:/final_corrected_genome.gff") or die "$!";
open (INCOV,"<E:/CH_1_heart_R1_val_1_bismark_bt2_pe.deduplicated.bismark.cov") or die "$!";
open (OUT,">E:/CH_1_heart_methylation_rate_per_gene.txt") or die "$!";

my %gff_data = ();
while (<INGFF>) {
	chomp (my $gff_data = $_);
	my @gff_data = split (/\t/,$gff_data);
	if ($gff_data[2] eq "mRNA") {
		my @attributes = split (/[\=\;]/,$gff_data[8]);
		$gff_data{$attributes[5]}{"chr_ID"} = $gff_data[0];
		if ($gff_data[6] eq "+") {
			$gff_data{$attributes[5]}{"strat"} = $gff_data[3] - 1000;
			$gff_data{$attributes[5]}{"end"} = $gff_data[4];
		} elsif ($gff_data[6] eq "-") {
			$gff_data{$attributes[5]}{"strat"} = $gff_data[3];
			$gff_data{$attributes[5]}{"end"} = $gff_data[4] + 1000;
		}	
		$gff_data{$attributes[5]}{"orientation"} = $gff_data[6];
	}
	
}
close (INGFF);

my %cov_data = ();
while (<INCOV>) {
	chomp (my $cov_data = $_);
	my @cov_data = split (/\t/,$cov_data);
	$cov_data{$cov_data[0]}{$cov_data[1]}{"methyled"} = $cov_data[4];
	$cov_data{$cov_data[0]}{$cov_data[1]}{"unmethyled"} = $cov_data[5];
}
close (INCOV);

foreach my $key1 (sort {$a cmp $b} keys %gff_data) {
	my $chr_ID = $gff_data{$key1}{"chr_ID"};
	my $orientation = $gff_data{$key1}{"orientation"};
	my $methyl_count = 0;
	my $unmethyl_count = 1;
	my $start = $gff_data{$key1}{"strat"};
	my $end = $gff_data{$key1}{"end"};
	for (my $i = $start;$i <= $end;$i++) {
		if (exists $cov_data{$chr_ID}{$i}) {
			$methyl_count += $cov_data{$chr_ID}{$i}{"methyled"};
			$unmethyl_count += $cov_data{$chr_ID}{$i}{"unmethyled"};
		}
		last if ($i > $end);
	}
	my $result = $methyl_count / ($methyl_count + $unmethyl_count);
	$result = sprintf ("%.3f",$result);
	if ($methyl_count == 0 and $unmethyl_count == 1) {
		$methyl_count = 0;
		$unmethyl_count = 0;
	}
	print OUT "$key1\t$chr_ID\t$start\t$end\t$orientation\t$methyl_count\t$unmethyl_count\t$result\n";
}
close (OUT);



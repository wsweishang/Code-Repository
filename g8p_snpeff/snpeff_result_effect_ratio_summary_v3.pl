#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
#open (GENEIDPATH, "<$ARGV[0]") or die "$!";
open (TARGETEFFECT, "<$ARGV[0]") or die "$!";
open (SNPEFFSUMMARY, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";
my $threshold = $ARGV[3];
#####################################################################################################
#my (%target_gene) = ();
#while (<GENEIDPATH>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^#.*/);
#	my @data = split (/\t/, $data);
#	my ($name, $path) = @data[0..1];
#	open (IN, "<$path") or die "$!";
#	while (<IN>) {
#		chomp (my $gene_id = $_);
#		next if ($gene_id =~ /^#.*/);
#		push (@{$target_gene{$gene_id}}, $name);
#	}
#	close (IN);
#}
#close (GENEIDPATH);
#####################################################################################################
my (%target_effect) = ();
while (<TARGETEFFECT>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	$target_effect{$data} = 1;
}
close (TARGETEFFECT);
#####################################################################################################
my (%summary) = ();
while (<SNPEFFSUMMARY>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	(my $gene_id = $data[6]) =~ s/.*(CI\d{8}_\d{8}_\d{8}).*/$1/;
	$data[7] =~ /(.*) \((.*),.*\)/;
	my $in_ratio = $1 / ($1 + $2);
	$data[8] =~ /(.*) \((.*),.*\)/;
	my $tj_ratio = $1 / ($1 + $2);
	$data[9] =~ /(.*) \((.*),.*\)/;
	my $wz_ratio = $1 / ($1 + $2);
	
	if ($in_ratio >= $threshold) {
		$summary{"IN_target_background_gene"}{$gene_id} = 1;
		$summary{"IN_target_background_snp"}++;
		if (exists $target_effect{$data[4]}) {
			$summary{$data[4]}{"IN_target_effect_gene"}{$gene_id} = 1;
			$summary{$data[4]}{"IN_target_effect_snp"}++;
		}
	} else {
		$summary{"IN_total_background_gene"}{$gene_id} = 1;
		$summary{"IN_total_background_snp"}++;
		if (exists $target_effect{$data[4]}) {
			$summary{$data[4]}{"IN_total_effect_gene"}{$gene_id} = 1;
			$summary{$data[4]}{"IN_total_effect_snp"}++;
		}
	}
	
	if ($tj_ratio >= $threshold) {
		$summary{"TJ_target_background_gene"}{$gene_id} = 1;
		$summary{"TJ_target_background_snp"}++;
		if (exists $target_effect{$data[4]}) {
			$summary{$data[4]}{"TJ_target_effect_gene"}{$gene_id} = 1;
			$summary{$data[4]}{"TJ_target_effect_snp"}++;
		}
	} else {
		$summary{"TJ_total_background_gene"}{$gene_id} = 1;
		$summary{"TJ_total_background_snp"}++;
		if (exists $target_effect{$data[4]}) {
			$summary{$data[4]}{"TJ_total_effect_gene"}{$gene_id} = 1;
			$summary{$data[4]}{"TJ_total_effect_snp"}++;
		}
	}
	
	if ($wz_ratio >= $threshold) {
		$summary{"WZ_target_background_gene"}{$gene_id} = 1;
		$summary{"WZ_target_background_snp"}++;
		if (exists $target_effect{$data[4]}) {
			$summary{$data[4]}{"WZ_target_effect_gene"}{$gene_id} = 1;
			$summary{$data[4]}{"WZ_target_effect_snp"}++;
		}
	} else {
		$summary{"WZ_total_background_gene"}{$gene_id} = 1;
		$summary{"WZ_total_background_snp"}++;
		if (exists $target_effect{$data[4]}) {
			$summary{$data[4]}{"WZ_total_effect_gene"}{$gene_id} = 1;
			$summary{$data[4]}{"WZ_total_effect_snp"}++;
		}
	}
}
close (SNPEFFSUMMARY);

print OUT "#Effect\tIN_gene_ratio\tIN_total_gene_ratio\tIN_snp_ratio\tIN_total_snp_ratio\tTJ_gene_ratio\tTJ_total_gene_ratio\tTJ_snp_ratio\tTJ_total_snp_ratio\tWZ_gene_ratio\tWZ_total_gene_ratio\tWZ_snp_ratio\tWZ_total_snp_ratio\n";
foreach my $target_effect (sort {$a cmp $b} keys %target_effect) {
	print OUT "$target_effect\t";
	
	my $in_total_background_gene = scalar keys %{$summary{"IN_total_background_gene"}};
	my $in_total_effect_gene = scalar keys %{$summary{$target_effect}{"IN_total_effect_gene"}};
	my $in_target_background_gene = scalar keys %{$summary{"IN_target_background_gene"}};
	my $in_target_effect_gene = scalar keys %{$summary{$target_effect}{"IN_target_effect_gene"}};
	$in_total_effect_gene = 0 unless ($in_total_effect_gene);
	$in_target_effect_gene = 0 unless ($in_target_effect_gene);
	print OUT $in_target_effect_gene / $in_target_background_gene, " ($in_target_effect_gene, $in_target_background_gene)\t";
	print OUT $in_total_effect_gene / $in_total_background_gene, " ($in_total_effect_gene, $in_total_background_gene)\t";
	my $in_total_background_snp = $summary{"IN_total_background_snp"};
	my $in_total_effect_snp = $summary{$target_effect}{"IN_total_effect_snp"};
	my $in_target_background_snp = $summary{"IN_target_background_snp"};
	my $in_target_effect_snp = $summary{$target_effect}{"IN_target_effect_snp"};
	$in_total_effect_snp = 0 unless ($in_total_effect_snp);
	$in_target_effect_snp = 0 unless ($in_target_effect_snp);
	print OUT $in_target_effect_snp / $in_target_background_snp, " ($in_target_effect_snp, $in_target_background_snp)\t";
	print OUT $in_total_effect_snp / $in_total_background_snp, " ($in_total_effect_snp, $in_total_background_snp)\t";
	
	my $tj_total_background_gene = scalar keys %{$summary{"TJ_total_background_gene"}};
	my $tj_total_effect_gene = scalar keys %{$summary{$target_effect}{"TJ_total_effect_gene"}};
	my $tj_target_background_gene = scalar keys %{$summary{"TJ_target_background_gene"}};
	my $tj_target_effect_gene = scalar keys %{$summary{$target_effect}{"TJ_target_effect_gene"}};
	$tj_total_effect_gene = 0 unless ($tj_total_effect_gene);
	$tj_target_effect_gene = 0 unless ($tj_target_effect_gene);
	print OUT $tj_target_effect_gene / $tj_target_background_gene, " ($tj_target_effect_gene, $tj_target_background_gene)\t";
	print OUT $tj_total_effect_gene / $tj_total_background_gene, " ($tj_total_effect_gene, $tj_total_background_gene)\t";
	my $tj_total_background_snp = $summary{"TJ_total_background_snp"};
	my $tj_total_effect_snp = $summary{$target_effect}{"TJ_total_effect_snp"};
	my $tj_target_background_snp = $summary{"TJ_target_background_snp"};
	my $tj_target_effect_snp = $summary{$target_effect}{"TJ_target_effect_snp"};
	$tj_total_effect_snp = 0 unless ($tj_total_effect_snp);
	$tj_target_effect_snp = 0 unless ($tj_target_effect_snp);
	print OUT $tj_target_effect_snp / $tj_target_background_snp, " ($tj_target_effect_snp, $tj_target_background_snp)\t";
	print OUT $tj_total_effect_snp / $tj_total_background_snp, " ($tj_total_effect_snp, $tj_total_background_snp)\t";
	
	my $wz_total_background_gene = scalar keys %{$summary{"WZ_total_background_gene"}};
	my $wz_total_effect_gene = scalar keys %{$summary{$target_effect}{"WZ_total_effect_gene"}};
	my $wz_target_background_gene = scalar keys %{$summary{"WZ_target_background_gene"}};
	my $wz_target_effect_gene = scalar keys %{$summary{$target_effect}{"WZ_target_effect_gene"}};
	$wz_total_effect_gene = 0 unless ($wz_total_effect_gene);
	$wz_target_effect_gene = 0 unless ($wz_target_effect_gene);
	print OUT $wz_target_effect_gene / $wz_target_background_gene, " ($wz_target_effect_gene, $wz_target_background_gene)\t";
	print OUT $wz_total_effect_gene / $wz_total_background_gene, " ($wz_total_effect_gene, $wz_total_background_gene)\t";
	my $wz_total_background_snp = $summary{"WZ_total_background_snp"};
	my $wz_total_effect_snp = $summary{$target_effect}{"WZ_total_effect_snp"};
	my $wz_target_background_snp = $summary{"WZ_target_background_snp"};
	my $wz_target_effect_snp = $summary{$target_effect}{"WZ_target_effect_snp"};
	$wz_total_effect_snp = 0 unless ($wz_total_effect_snp);
	$wz_target_effect_snp = 0 unless ($wz_target_effect_snp);
	print OUT $wz_target_effect_snp / $wz_target_background_snp, " ($wz_target_effect_snp, $wz_target_background_snp)\t";
	print OUT $wz_total_effect_snp / $wz_total_background_snp, " ($wz_total_effect_snp, $wz_total_background_snp)\n";
}
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;

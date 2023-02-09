#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (GENEIDPATH, "<$ARGV[0]") or die "$!";
open (TARGETEFFECT, "<$ARGV[1]") or die "$!";
open (SNPEFFSUMMARY, "<$ARGV[2]") or die "$!";
open (OUT, ">$ARGV[3]") or die "$!";
#####################################################################################################
my (%target_gene) = ();
while (<GENEIDPATH>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	my ($name, $path) = @data[0..1];
	open (IN, "<$path") or die "$!";
	while (<IN>) {
		chomp (my $gene_id = $_);
		next if ($gene_id =~ /^#.*/);
		push (@{$target_gene{$gene_id}}, $name);
	}
	close (IN);
}
close (GENEIDPATH);
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
	if (exists $target_gene{$gene_id}) {
		$summary{"target_background_gene"}{$gene_id} = 1;
		$summary{"target_background_snp"}++;
		if (exists $target_effect{$data[4]}) {
			$summary{$data[4]}{"target_effect_gene"}{$gene_id} = 1;
			$summary{$data[4]}{"target_effect_snp"}++;
		}
	} else {
		$summary{"total_background_gene"}{$gene_id} = 1;
		$summary{"total_background_snp"}++;
		if (exists $target_effect{$data[4]}) {
			$summary{$data[4]}{"total_effect_gene"}{$gene_id} = 1;
			$summary{$data[4]}{"total_effect_snp"}++;
		}
	}
}
close (SNPEFFSUMMARY);

print OUT "#Effect\tSelected_gene_ratio\tTotal_gene_ratio\tSelected_snp_ratio\tTotal_snp_ratio\n";
foreach my $target_effect (sort {$a cmp $b} keys %target_effect) {
	print OUT "$target_effect\t";
	my $total_background_gene = scalar keys %{$summary{"total_background_gene"}};
	my $total_effect_gene = scalar keys %{$summary{$target_effect}{"total_effect_gene"}};
	my $target_background_gene = scalar keys %{$summary{"target_background_gene"}};
	my $target_effect_gene = scalar keys %{$summary{$target_effect}{"target_effect_gene"}};
	$total_effect_gene = 0 unless ($total_effect_gene);
	$target_effect_gene = 0 unless ($target_effect_gene);
	print OUT $target_effect_gene / $target_background_gene, " ($target_effect_gene, $target_background_gene)\t";
	print OUT $total_effect_gene / $total_background_gene, " ($total_effect_gene, $total_background_gene)\t";
	my $total_background_snp = $summary{"total_background_snp"};
	my $total_effect_snp = $summary{$target_effect}{"total_effect_snp"};
	my $target_background_snp = $summary{"target_background_snp"};
	my $target_effect_snp = $summary{$target_effect}{"target_effect_snp"};
	$total_effect_snp = 0 unless ($total_effect_snp);
	$target_effect_snp = 0 unless ($target_effect_snp);
	print OUT $target_effect_snp / $target_background_snp, " ($target_effect_snp, $target_background_snp)\t";
	print OUT $total_effect_snp / $total_background_snp, " ($total_effect_snp, $total_background_snp)\n";
}
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;

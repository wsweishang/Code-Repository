#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (VCF, "<D:/t.txt") or die "$!";
open (OUT, ">D:/out.txt") or die "$!";
#####################################################################################################
my ($loci, @sample_name, @sample_population, @population_name, %snp_ratio) = ();
while (<VCF>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		if ($data =~ /^#[^#]+.*/) {
			my %hash = ();
			my @data = split (/\t/, $data);
			@sample_name = splice (@data, 9);
			@sample_population = map {substr ($_, -4, -2)} @sample_name;
			@population_name = grep {++$hash{$_} < 2} @sample_population;
		}
		next;
	}
	my @data = split (/\t/, $data);
	my ($chr, $pos, $ref, $alt, $info) = ($data[0], $data[1], $data[3], $data[4], $data[7]);
	my @sample = splice (@data, 9);
	my @alt = split (/,/, $alt);
	unshift (@alt, $ref);
	my (%temp_ratio, $count) = ();
	for (my $i = 0; $i <= $#sample; $i++) {
		my $a = substr ($sample[$i], 0, 1);
		my $b = substr ($sample[$i], 2, 1);
		if ($a ne ".") {
			$temp_ratio{$alt[$a]}{$sample_population[$i]}++;
			$count++;
		}
		if ($b ne ".") {
			$temp_ratio{$alt[$b]}{$sample_population[$i]}++;
			$count++;
		}
	}
	my @info = split (/;/, $data[7]);
	$info[-1] .= ".";
	my @ann = split (/\|/, $info[-1]);
	my $num = int ((scalar @ann) / 15);
	
	for (my $p = 1; $p <= $num; $p++) {
		my $allele = substr ($ann[($p - 1) * 15], -1, 1);
		my $effect = $ann[($p - 1) * 15 + 1];
		my $impact = $ann[($p - 1) * 15 + 2];
		my $gene_id = $ann[($p - 1) * 15 + 3];
		my @effect = split (/&/, $effect);
		foreach my $effect (@effect) {
			$loci++;
			$snp_ratio{$loci}{"loci"} = "$chr\t$pos";
			$snp_ratio{$loci}{"ref"} = $ref;
			$snp_ratio{$loci}{"allele"} = $allele;
			$snp_ratio{$loci}{"effect"} = $effect;
			$snp_ratio{$loci}{"impact"} = $impact;
			$snp_ratio{$loci}{"gene_id"} = $gene_id;
			foreach my $sample_population (@sample_population) {
				if (exists $temp_ratio{$allele}{$sample_population}) {
					$snp_ratio{$loci}{$sample_population} = "$temp_ratio{$allele}{$sample_population}";
					if (exists $temp_ratio{$ref}{$sample_population}) {
						$snp_ratio{$loci}{$sample_population} .= " ($temp_ratio{$ref}{$sample_population}, $count)";
					} else {
						$snp_ratio{$loci}{$sample_population} .= " (NA, $count)";
					}
				} else {
					$snp_ratio{$loci}{$sample_population} = "NA";
					if (exists $temp_ratio{$ref}{$sample_population}) {
						$snp_ratio{$loci}{$sample_population} .= " ($temp_ratio{$ref}{$sample_population}, $count)";
					} else {
						$snp_ratio{$loci}{$sample_population} .= " (NA, $count)";
					}
				}
			}
		}
	}
}
close (VCF);

print OUT "#chr\tpos\tref\talt\teffect\timpact\tgene_id\t", join ("\t", @population_name), "\n";
foreach my $position (sort {$a <=> $b} keys %snp_ratio) {
	print OUT $snp_ratio{$position}{"loci"}, "\t";
	print OUT $snp_ratio{$position}{"ref"}, "\t";
	print OUT $snp_ratio{$position}{"allele"}, "\t";
	print OUT $snp_ratio{$position}{"effect"}, "\t";
	print OUT $snp_ratio{$position}{"impact"}, "\t";
	print OUT $snp_ratio{$position}{"gene_id"};
	map {print OUT "\t$snp_ratio{$position}{$_}"} @population_name;
	print OUT "\n";
}
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
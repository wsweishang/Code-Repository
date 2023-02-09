#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (INVCF, "<D:/research work/Coilia_nasus/3.statistics/04.haplotype_network/test1/haplotype_chr1_118556_128730_phased.vcf") or die "$!";
open (INPOP, "<D:/research work/Coilia_nasus/3.statistics/04.haplotype_network/test1/pop.txt") or die "$!";
open (OUT, ">D:/research work/Coilia_nasus/3.statistics/04.haplotype_network/test1/haplotype_chr1_118556_128730_phased.fas") or die "$!";

my $region = "1:118556-128730";
$region =~ /(\w+):(\w+)-(\w+)/;
#$ARGV[3] =~ /(\w+):(\w+)-(\w+)/;
my ($chr, $start, $end) = ($1, $2, $3);

my ($i, @header, %vcf) = ();
while (<INVCF>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		@header = split (/\t/, $data) if ($data =~ /^#[^#].*/);
		next;
	}
	my @data = split (/\t/, $data);
	if ($data[0] eq $chr) {
		if ($data[1] >= $start and $data[1] <= $end) {
			$i++;
			map {push (@{$vcf{$i}}, $_)} @data;
		}
	}
}
close (INVCF);

my (%haplotype) = ();
foreach my $g (sort {$a <=> $b} keys %vcf) {
	my @vcf = @{$vcf{$g}};
	for (my $h = 9; $h <= $#vcf; $h++) {
		my $first = substr ($vcf[$h], 0, 1);
		my $second = substr ($vcf[$h], 2, 1);
		my ($first_allele, $second_allele) = ();
		$first_allele = $vcf[3] if ($first == 0);
		$first_allele = $vcf[4] if ($first == 1);
		$second_allele = $vcf[3] if ($second == 0);
		$second_allele = $vcf[4] if ($second == 1);
		$haplotype{$header[$h]}{"1"} .= $first_allele;
		$haplotype{$header[$h]}{"2"} .= $second_allele;
	}
}

while (<INPOP>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	if (exists $haplotype{$data[0]}) {
		print OUT ">$data[0].1\t", join ("\t", @data[1..$#data]), "\n";
		print OUT $haplotype{$data[0]}{"1"}, "\n";
		print OUT ">$data[0].2\t", join ("\t", @data[1..$#data]), "\n";
		print OUT $haplotype{$data[0]}{"2"}, "\n";
	} else {
		print STDERR "$data[0]\n";
	}
}
close (INPOP);
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
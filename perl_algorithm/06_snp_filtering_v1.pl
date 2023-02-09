#!/usr/bin/perl

use strict;
use warnings;

open (INSNPVCF,"<$ARGV[0]") or die "$!";
open (ININDELVCF,"<$ARGV[1]") or die "$!";
open (INSCAFFOLDPOSLIST,"<$ARGV[2]") or die "$!";
my $snp_nbp_around_snp = $ARGV[3];
my $snp_nbp_around_indel = $ARGV[4];
my $snp_nbp_of_head_and_tail = $ARGV[5];
my $snp_min_depth = $ARGV[6];
my $AD_min_ratio = $ARGV[7];
open (OUT,"<$ARGV[8]") or die "$!";

my %indel_vcf_site = ();
while (<ININDELVCF>) {
	chomp (my $indel_vcf_data = $_);
	next if ($indel_vcf_data =~ /^#.*/);
	my @indel_vcf_data = split (/\t/,$indel_vcf_data);
	push (@{$indel_vcf_site{$indel_vcf_data[0]}}, $indel_vcf_data[1]);
}
close (ININDELVCF);

my %scaffold_list = ();
while (<INSCAFFOLDPOSLIST>) {
	chomp (my $scaffold_list_data = $_);
	next if ($scaffold_list_data =~ /^LG.*/);
	my @scaffold_list_data = split (/\t/,$scaffold_list_data);
	my $end = $scaffold_list_data[3] + $scaffold_list_data[2] - 1;
	push (@{$scaffold_list{$scaffold_list_data[0]}{"start"}}, $scaffold_list_data[3]);
	push (@{$scaffold_list{$scaffold_list_data[0]}{"end"}}, $end);
}
close (INSCAFFOLDPOSLIST);

my $LG_number = "LG00";
my @main_array = ();
my $first_start_site = -$snp_nbp_of_head_and_tail;
while (<INSNPVCF>) {
	chomp (my $snp_vcf_data = $_);
	next if ($snp_vcf_data =~ /^#.*/);
	my @snp_vcf_data = split (/\t/,$snp_vcf_data);
	if ($snp_vcf_data[0] ne $LG_number) {
		undef @main_array;
		$LG_number = $snp_vcf_data[0];
		foreach my $indel_vcf_site (@{$indel_vcf_site{$snp_vcf_data[0]}}) {
			my $left = $indel_vcf_site - $snp_nbp_around_indel;
			my $right = $indel_vcf_site + $snp_nbp_around_indel;
			for (my $i = $left ; $i <= $right ; $i++) {
				$main_array[$i] = "indel";
			}
		}
		foreach my $scaffold_start_site (@{$scaffold_list{$snp_vcf_data[0]}{"start"}}) {
			my $end = $scaffold_start_site + $snp_nbp_of_head_and_tail;
			for (my $i = $scaffold_start_site ; $i <= $end ; $i++) {
				$main_array[$i] = "start";
			}
		}
		foreach my $scaffold_end_site (@{$scaffold_list{$snp_vcf_data[0]}{"end"}}) {
			my $start = $scaffold_end_site - $snp_nbp_of_head_and_tail;
			for (my $i = $start ; $i <= $scaffold_end_site ; $i++) {
				$main_array[$i] = "end";
			}
		}
	}
	if (!$snp_vcf_data[1]) {
		if (($snp_vcf_data[1] - $first_start_site) > $snp_nbp_around_snp) {
			print OUT "$snp_vcf_data\n";
		} else {
			
			
			
			
			
			
			
		}
	}
	
	
	
	
	
	
	
	
	
	
}
close (INSNPVCF);






































































close (OUT);
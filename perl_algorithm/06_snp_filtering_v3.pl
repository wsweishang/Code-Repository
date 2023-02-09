#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

#open (INSNPVCF,"<$ARGV[0]") or die "$!";
#open (ININDELVCF,"<$ARGV[1]") or die "$!";
#open (INSCAFFOLDPOSLIST,"<$ARGV[2]") or die "$!";
#open (OUT,"<$ARGV[8]") or die "$!";
#my $snp_nbp_around_snp = $ARGV[3];
#my $snp_nbp_around_indel = $ARGV[4];
#my $snp_nbp_of_head_and_tail = $ARGV[5];
#my $snp_min_depth = $ARGV[6];
#my $AD_min_ratio = $ARGV[7];

open (INSNPVCF,"<E:/AX_S4_263Scafford.snp.eff.vcf") or die "$!";
open (ININDELVCF,"<E:/AX_S4_263Scafford.indels.eff.vcf") or die "$!";
open (INSCAFFOLDPOSLIST,"<E:/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt") or die "$!";
open (OUT,">E:/test.vcf") or die "$!";
my $snp_nbp_around_snp = 5;
my $snp_nbp_around_indel = 5;
my $snp_nbp_of_head_and_tail = 200;

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
	push (@{$scaffold_list{"LG$scaffold_list_data[0]"}{"start"}}, $scaffold_list_data[3]);
	push (@{$scaffold_list{"LG$scaffold_list_data[0]"}{"end"}}, $end);
}
close (INSCAFFOLDPOSLIST);

my %snp_vcf_site = ();
my %snp_vcf_info = ();
my @LG_order = ();
my $LG_number = "LG00";
while (<INSNPVCF>) {
	chomp (my $snp_vcf_data = $_);
	next if ($snp_vcf_data =~ /^#.*/);
	my @snp_vcf_data = split (/\t/,$snp_vcf_data);
	push (@{$snp_vcf_site{$snp_vcf_data[0]}{"site"}}, $snp_vcf_data[1]);
	$snp_vcf_info{$snp_vcf_data[0]}{$snp_vcf_data[1]} = $snp_vcf_data;
	if ($snp_vcf_data[0] ne $LG_number) {
		push (@LG_order, $snp_vcf_data[0]);
		$LG_number = $snp_vcf_data[0];
	}
}
close (INSNPVCF);

my @snp_array = ();
my @main_array = ();
foreach my $LG_number (@LG_order) {
	print "$LG_number\n";
	foreach my $indel_vcf_site (@{$indel_vcf_site{$LG_number}}) {
		my $left = $indel_vcf_site - $snp_nbp_around_indel;
		my $right = $indel_vcf_site + $snp_nbp_around_indel;
		for (my $i = $left ; $i <= $right ; $i++) {
			$main_array[$i] = "indel";
		}
	}
	foreach my $scaffold_start_site (@{$scaffold_list{$LG_number}{"start"}}) {
		my $end = $scaffold_start_site + $snp_nbp_of_head_and_tail;
		for (my $i = $scaffold_start_site ; $i <= $end ; $i++) {
			$main_array[$i] = "start";
		}
	}
	foreach my $scaffold_end_site (@{$scaffold_list{$LG_number}{"end"}}) {
		my $start = $scaffold_end_site - $snp_nbp_of_head_and_tail;
		for (my $i = $start ; $i <= $scaffold_end_site ; $i++) {
			$main_array[$i] = "end";
		}
	}
	@snp_array = @{$snp_vcf_site{$LG_number}{"site"}};
	my $last_snp_site = -$snp_nbp_around_snp;
	unshift (@snp_array, $last_snp_site);
	my $length = $#snp_array;
	for (my $i = 1 ; $i <= $length ; $i++) {
		my $last_snp_site = $snp_array[$i-1];
		my $current_snp_site = $snp_array[$i];
		if ($snp_array[$i+1]) {
			my $next_snp_site = $snp_array[$i+1];
			my $left = $current_snp_site - $last_snp_site;
			my $right = $next_snp_site - $current_snp_site;
			if (($left > $snp_nbp_around_snp) and ($right > $snp_nbp_around_snp)) {
				unless ($main_array[$current_snp_site]) {
					print OUT "$snp_vcf_info{$LG_number}{$snp_array[$i]}\n";
				}
			}
		} else {
			my $left = $current_snp_site - $last_snp_site;
			if ($left > $snp_nbp_around_snp) {
				unless ($main_array[$current_snp_site]) {
					print OUT "$snp_vcf_info{$LG_number}{$snp_array[$i]}\n";
				}
			}
		}
	}
}

close (OUT);

print "finished\n";




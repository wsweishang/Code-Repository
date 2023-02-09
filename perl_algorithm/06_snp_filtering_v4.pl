#!/usr/bin/perl
#weishang presents

use strict;
use warnings;
#============================================================================================================================
#open (INSNPVCF,"<$ARGV[0]") or die "$!";
#open (ININDELVCF,"<$ARGV[1]") or die "$!";
#open (INSCAFFOLDPOSLIST,"<$ARGV[2]") or die "$!";
#open (OUT,"<$ARGV[8]") or die "$!";
#my $snp_nbp_around_snp = $ARGV[3];
#my $snp_nbp_around_indel = $ARGV[4];
#my $snp_nbp_of_head_and_tail = $ARGV[5];
#============================================================================================================================
open (INSNPVCF,"<E:/AX_S4_263Scafford.snp.eff.vcf") or die "$!";
open (ININDELVCF,"<E:/AX_S4_263Scafford.indels.eff.vcf") or die "$!";
open (INSCAFFOLDPOSLIST,"<E:/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt") or die "$!";
open (OUT,">E:/test.vcf") or die "$!";
my $nbp_between_snp_and_snp = 5;
my $nbp_between_snp_and_indel = 5;
my $nbp_on_head_and_tail = 200;
my $min_snp_valid_depth = 10;
my $min_ref_alt_frequency_ratio = 0.5;
print "script filter parameter : 
	snp vcf path : E:/AX_S4_263Scafford.snp.eff.vcf
	indel vcf path : E:/AX_S4_263Scafford.indels.eff.vcf
	scaffold/chromesome list path : E:/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt
	output snp vcf path : E:/test.vcf 
	nbp between snp and snp = $nbp_between_snp_and_snp
	nbp between snp and indel = $nbp_between_snp_and_indel
	nbp on head and tail = $nbp_on_head_and_tail
	min snp valid depth = $min_snp_valid_depth
	min ref/alt frequency ratio = $min_ref_alt_frequency_ratio\n";
print "initializing...\n";
#============================================================================================================================
my %indel_vcf_site = ();
while (<ININDELVCF>) {
	chomp (my $indel_vcf_data = $_);
	next if ($indel_vcf_data =~ /^#.*/);
	my @indel_vcf_data = split (/\t/,$indel_vcf_data);
	push (@{$indel_vcf_site{$indel_vcf_data[0]}}, $indel_vcf_data[1]);
}
close (ININDELVCF);
#============================================================================================================================
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
#============================================================================================================================
my %snp_vcf_site = ();
my %snp_vcf_info = ();
my $head = ();
my @LG_order = ();
my $LG_number = "LG00";
while (<INSNPVCF>) {
	my $snp_vcf_data = $_;
	if ($snp_vcf_data =~ /^#.*/) {
		$head .= $snp_vcf_data;
		next;
	}
	chomp $snp_vcf_data;
	my @snp_vcf_data = split (/\t/,$snp_vcf_data);
	my @info = split (/:/,$snp_vcf_data[8]);
	my @sample = split (/:/,$snp_vcf_data[9]);
	push (@{$snp_vcf_site{$snp_vcf_data[0]}{"site"}}, $snp_vcf_data[1]);
	for (my $i = 0 ; $i <= $#info ; $i++) {
		$snp_vcf_site{$snp_vcf_data[0]}{$snp_vcf_data[1]}{$info[$i]} = $sample[$i];
	}
	@{$snp_vcf_info{$snp_vcf_data[0]}{$snp_vcf_data[1]}} = @snp_vcf_data;
	if ($snp_vcf_data[0] ne $LG_number) {
		push (@LG_order, $snp_vcf_data[0]);
		$LG_number = $snp_vcf_data[0];
	}
}
close (INSNPVCF);
#============================================================================================================================
print OUT "$head";
print OUT "##perl filter script version : $0\n";
print OUT "##script filter parameter : nbp_between_snp_and_snp = $nbp_between_snp_and_snp nbp_between_snp_and_indel = $nbp_between_snp_and_indel nbp_on_head_and_tail = $nbp_on_head_and_tail min_snp_valid_depth = $min_snp_valid_depth min_ref/alt_frequency_ratio = $min_ref_alt_frequency_ratio\n";
print OUT "##FILTER=<ID=UNPASS,Description='unpass filter by perl script'>\n";
#============================================================================================================================
my @snp_array = ();
my @main_array = ();
foreach my $LG_number (@LG_order) {
	print "processing : $LG_number...\n";
	foreach my $indel_vcf_site (@{$indel_vcf_site{$LG_number}}) {
		my $left = $indel_vcf_site - $nbp_between_snp_and_indel;
		my $right = $indel_vcf_site + $nbp_between_snp_and_indel;
		for (my $i = $left ; $i <= $right ; $i++) {
			$main_array[$i] = "indel";
		}
	}
	foreach my $scaffold_start_site (@{$scaffold_list{$LG_number}{"start"}}) {
		my $end = $scaffold_start_site + $nbp_on_head_and_tail;
		for (my $i = $scaffold_start_site ; $i <= $end ; $i++) {
			$main_array[$i] = "start";
		}
	}
	foreach my $scaffold_end_site (@{$scaffold_list{$LG_number}{"end"}}) {
		my $start = $scaffold_end_site - $nbp_on_head_and_tail;
		for (my $i = $start ; $i <= $scaffold_end_site ; $i++) {
			$main_array[$i] = "end";
		}
	}
	@snp_array = @{$snp_vcf_site{$LG_number}{"site"}};
	my $last_snp_site = -$nbp_between_snp_and_snp;
	unshift (@snp_array, $last_snp_site);
	my $length = $#snp_array;
	for (my $i = 1 ; $i <= $length ; $i++) {
		my $last_snp_site = $snp_array[$i-1];
		my $current_snp_site = $snp_array[$i];
		if ($snp_array[$i+1]) {
			my $next_snp_site = $snp_array[$i+1];
			my $left = $current_snp_site - $last_snp_site;
			my $right = $next_snp_site - $current_snp_site;
			if (($left > $nbp_between_snp_and_snp) and ($right > $nbp_between_snp_and_snp)) {
				unless ($main_array[$current_snp_site]) {
					my ($reference_depth, $allel_depth) = (split (/,/, $snp_vcf_site{$LG_number}{$current_snp_site}{"AD"}))[0,1];
					my $depth = $reference_depth + $allel_depth;
					my $ratio = $allel_depth / $depth;
					if (($depth >= $min_snp_valid_depth) and ($ratio >= $min_ref_alt_frequency_ratio)) {
						print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
					} else {
						@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "UNPASS";
						print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
					}
				} else {
					@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "UNPASS";
					print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
				} 
			} else {
				@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "UNPASS";
				print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
			}
		} else {
			my $left = $current_snp_site - $last_snp_site;
			if ($left > $nbp_between_snp_and_snp) {
				unless ($main_array[$current_snp_site]) {
					my ($reference_depth, $allel_depth) = (split (/,/, $snp_vcf_site{$LG_number}{$current_snp_site}{"AD"}))[0,1];
					my $depth = $reference_depth + $allel_depth;
					my $ratio = $allel_depth / $depth;
					if (($depth >= $min_snp_valid_depth) and ($ratio >= $min_ref_alt_frequency_ratio)) {
						print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
					} else {
						@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "UNPASS";
						print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
					}
				} else {
					@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "UNPASS";
					print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
				}
			} else {
				@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "UNPASS";
				print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
			}
		}
	}
}
#============================================================================================================================
close (OUT);
print "finished\n";
#!/usr/bin/perl

use strict;
use warnings;
#============================================================================================================================
open (ININDELVCF,"<$ARGV[0]") or die "$!";
open (INSCAFFOLDPOSLIST,"<$ARGV[1]") or die "$!";
open (OUT,">$ARGV[2]") or die "$!";
my $nbp_between_indel_and_indel = $ARGV[3];
my $nbp_on_head_and_tail = $ARGV[4];
my $min_indel_valid_depth = $ARGV[5];
my $min_ref_alt_frequency_ratio = $ARGV[6];
print "script filter parameter : 
	indel vcf path : $ARGV[0]
	scaffold/chromesome list path : $ARGV[1]
	output indel vcf path : $ARGV[2]
	nbp between indel and indel = $nbp_between_indel_and_indel
	nbp on head and tail = $nbp_on_head_and_tail
	min indel valid depth = $min_indel_valid_depth
	min alt/ref+alt frequency ratio = $min_ref_alt_frequency_ratio\n";
print "initializing...\n";
#============================================================================================================================
my %eliminate_vcf_site = ();
while (<INSCAFFOLDPOSLIST>) {
	chomp (my $scaffold_list_data = $_);
	next if ($scaffold_list_data =~ /^LG.*/);
	my @scaffold_list_data = split (/\t/,$scaffold_list_data);
	my $scaffold_head_start_site = $scaffold_list_data[3];
	my $scaffold_tail_end_site = $scaffold_list_data[3] + $scaffold_list_data[2] - 1;
	my $scaffold_head_end_site = $scaffold_head_start_site + $nbp_on_head_and_tail;
	my $scaffold_tail_start_site = $scaffold_tail_end_site - $nbp_on_head_and_tail;
	for (my $i = $scaffold_head_start_site ; $i <= $scaffold_head_end_site ; $i++) {
		$eliminate_vcf_site{"LG$scaffold_list_data[0]"}{$i} = "start";
	}
	for (my $i = $scaffold_tail_start_site ; $i <= $scaffold_tail_end_site ; $i++) {
		$eliminate_vcf_site{"LG$scaffold_list_data[0]"}{$i} = "end";
	}
}
close (INSCAFFOLDPOSLIST);
#============================================================================================================================
my %indel_vcf_site = ();
my %indel_vcf_info = ();
my $head = ();
my $header = ();
my @LG_order = ();
my $LG_number = "LG00";
while (<ININDELVCF>) {
	my $indel_vcf_data = $_;
	if ($indel_vcf_data =~ /^##.*/) {
		$head .= $indel_vcf_data;
		next;
	}
	if ($indel_vcf_data =~ /^#.*/) {
		$header = $indel_vcf_data;
		next;
	}
	chomp $indel_vcf_data;
	my @indel_vcf_data = split (/\t/,$indel_vcf_data);
	my @info = split (/:/,$indel_vcf_data[8]);
	my @sample = split (/:/,$indel_vcf_data[9]);
	push (@{$indel_vcf_site{$indel_vcf_data[0]}{"site"}}, $indel_vcf_data[1]);
	for (my $i = 0 ; $i <= $#info ; $i++) {
		$indel_vcf_site{$indel_vcf_data[0]}{$indel_vcf_data[1]}{$info[$i]} = $sample[$i];
	}
	@{$indel_vcf_info{$indel_vcf_data[0]}{$indel_vcf_data[1]}} = @indel_vcf_data;
	if ($indel_vcf_data[0] ne $LG_number) {
		push (@LG_order, $indel_vcf_data[0]);
		$LG_number = $indel_vcf_data[0];
	}
}
close (ININDELVCF);
#============================================================================================================================
print OUT "$head";
print OUT "##perl filter script version : $0\n";
print OUT "##script filter parameter:nbp_between_indel_and_indel=$nbp_between_indel_and_indel\n";
print OUT "##script filter parameter:nbp_on_head_and_tail=$nbp_on_head_and_tail\n";
print OUT "##script filter parameter:min_indel_valid_depth=$min_indel_valid_depth\n";
print OUT "##script filter parameter:min_alt/ref+alt_frequency_ratio=$min_ref_alt_frequency_ratio\n";
print OUT '##FILTER=<ID=LOWRatio,Description="The alt/ref+alt frequency ratio of this indel is lower than the parameter you set">' . "\n";
print OUT '##FILTER=<ID=LOWDepth,Description="The valid depth of this indel is lower than the parameter you set">' . "\n";
print OUT '##FILTER=<ID=NEAREdge,Description="This indel site is near the head/tail of scaffolds">' . "\n";
print OUT '##FILTER=<ID=NEARIndel,Description="This indel site is near another indel">' . "\n";
print OUT "$header";
#============================================================================================================================
my @indel_array = ();
foreach my $LG_number (@LG_order) {
	print "now processing : $LG_number...\n";
	undef (@indel_array);
	@indel_array = @{$indel_vcf_site{$LG_number}{"site"}};
	my $last_indel_site = -$nbp_between_indel_and_indel - 2;
	my $end_indel_site = $indel_array[-1] + $nbp_between_indel_and_indel + 2;
	unshift (@indel_array, $last_indel_site);
	push (@indel_array, $end_indel_site);
	for (my $i = 1 ; $i < $#indel_array ; $i++) {
		my $current_indel_site = $indel_array[$i];
		my $left = $indel_array[$i] - $indel_array[$i-1];
		my $right = $indel_array[$i+1] - $indel_array[$i];
		if (($left > $nbp_between_indel_and_indel) and ($right > $nbp_between_indel_and_indel)) {
			unless (exists $eliminate_vcf_site{$LG_number}{$current_indel_site}) {
				my ($reference_depth, $allel_depth) = (split (/,/, $indel_vcf_site{$LG_number}{$current_indel_site}{"AD"}))[0,1];
				my $depth = $indel_vcf_site{$LG_number}{$current_indel_site}{"DP"};
				my $ratio = $allel_depth / $depth;
				if ($depth >= $min_indel_valid_depth) {
					if ($ratio >= $min_ref_alt_frequency_ratio) {
						print OUT join ("\t", @{$indel_vcf_info{$LG_number}{$current_indel_site}}) . "\n";
					} else {
						@{$indel_vcf_info{$LG_number}{$current_indel_site}}[6] = "LOWRatio" if (@{$indel_vcf_info{$LG_number}{$current_indel_site}}[6] eq "PASS");
						print OUT join ("\t", @{$indel_vcf_info{$LG_number}{$current_indel_site}}) . "\n";
					}
				} else {
					@{$indel_vcf_info{$LG_number}{$current_indel_site}}[6] = "LOWDepth" if (@{$indel_vcf_info{$LG_number}{$current_indel_site}}[6] eq "PASS");
					print OUT join ("\t", @{$indel_vcf_info{$LG_number}{$current_indel_site}}) . "\n";
				}
			} else {
				@{$indel_vcf_info{$LG_number}{$current_indel_site}}[6] = "NEAREdge" if (@{$indel_vcf_info{$LG_number}{$current_indel_site}}[6] eq "PASS");
				print OUT join ("\t", @{$indel_vcf_info{$LG_number}{$current_indel_site}}) . "\n";
			} 
		} else {
			@{$indel_vcf_info{$LG_number}{$current_indel_site}}[6] = "NEARIndel" if (@{$indel_vcf_info{$LG_number}{$current_indel_site}}[6] eq "PASS");
			print OUT join ("\t", @{$indel_vcf_info{$LG_number}{$current_indel_site}}) . "\n";
		}
	}
}
close (OUT);
#============================================================================================================================
print "finished\n";




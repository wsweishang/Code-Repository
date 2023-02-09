#!/usr/bin/perl

use strict;
use warnings;
#============================================================================================================================
open (INSNPVCF,"<$ARGV[0]") or die "$!";
open (ININDELVCF,"<$ARGV[1]") or die "$!";
open (OUT,">$ARGV[2]") or die "$!";
my $nbp_between_snp_and_snp = $ARGV[3];
my $nbp_between_snp_and_indel = $ARGV[4];
my $min_snp_valid_depth = $ARGV[5];
my $min_ref_alt_frequency_ratio = $ARGV[6];
print "script filter parameter : 
	snp vcf path : $ARGV[0]
	indel vcf path : $ARGV[1]
	output snp vcf path : $ARGV[2]
	nbp between snp and snp = $nbp_between_snp_and_snp
	nbp between snp and indel = $nbp_between_snp_and_indel
	min snp valid depth = $min_snp_valid_depth
	min alt/ref+alt frequency ratio = $min_ref_alt_frequency_ratio\n";
print "initializing...\n";
#============================================================================================================================
my %eliminate_vcf_site = ();
while (<ININDELVCF>) {
	chomp (my $indel_vcf_data = $_);
	next if ($indel_vcf_data =~ /^#.*/);
	my @indel_vcf_data = split (/\t/,$indel_vcf_data);
	my $left = $indel_vcf_data[1] - $nbp_between_snp_and_indel;
	my $right = $indel_vcf_data[1] + $nbp_between_snp_and_indel;		
	for (my $i = $left ; $i <= $right ; $i++) {
		$eliminate_vcf_site{$indel_vcf_data[0]}{$i} = "indel"
	}
}
close (ININDELVCF);
#============================================================================================================================
my %snp_vcf_site = ();
my %snp_vcf_info = ();
my $head = ();
my $header = ();
my @LG_order = ();
my $LG_number = "LG00";
while (<INSNPVCF>) {
	my $snp_vcf_data = $_;
	if ($snp_vcf_data =~ /^##.*/) {
		$head .= $snp_vcf_data;
		next;
	}
	if ($snp_vcf_data =~ /^#.*/) {
		$header = $snp_vcf_data;
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
print OUT "##script filter parameter:nbp_between_snp_and_snp=$nbp_between_snp_and_snp\n";
print OUT "##script filter parameter:nbp_between_snp_and_indel=$nbp_between_snp_and_indel\n";
print OUT "##script filter parameter:min_snp_valid_depth=$min_snp_valid_depth\n";
print OUT "##script filter parameter:min_alt/ref+alt_frequency_ratio=$min_ref_alt_frequency_ratio\n";
print OUT '##FILTER=<ID=LOWRatio,Description="The alt/ref+alt frequency ratio of this snp is lower than the parameter you set">' . "\n";
print OUT '##FILTER=<ID=LOWDepth,Description="The valid depth of this snp is lower than the parameter you set">' . "\n";
print OUT '##FILTER=<ID=NEARIndel,Description="This snp site is near a indel">' . "\n";
print OUT '##FILTER=<ID=NEARSnp,Description="This snp site is near another snp">' . "\n";
print OUT "$header";
#============================================================================================================================
my @snp_array = ();
foreach my $LG_number (@LG_order) {
	print "now processing : $LG_number...\n";
	undef (@snp_array);
	@snp_array = @{$snp_vcf_site{$LG_number}{"site"}};
	my $last_snp_site = -$nbp_between_snp_and_snp - 2;
	my $end_snp_site = $snp_array[-1] + $nbp_between_snp_and_snp + 2;
	unshift (@snp_array, $last_snp_site);
	push (@snp_array, $end_snp_site);
	for (my $i = 1 ; $i < $#snp_array ; $i++) {
		my $current_snp_site = $snp_array[$i];
		my $left = $snp_array[$i] - $snp_array[$i-1];
		my $right = $snp_array[$i+1] - $snp_array[$i];
		if (($left > $nbp_between_snp_and_snp) and ($right > $nbp_between_snp_and_snp)) {
			unless (exists $eliminate_vcf_site{$LG_number}{$current_snp_site}) {
				my ($reference_depth, $allel_depth) = (split (/,/, $snp_vcf_site{$LG_number}{$current_snp_site}{"AD"}))[0,1];
				my $depth = $snp_vcf_site{$LG_number}{$current_snp_site}{"DP"};
				my $ratio = $allel_depth / $depth;
				if ($depth >= $min_snp_valid_depth) {
					if ($ratio >= $min_ref_alt_frequency_ratio) {
						print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
					} else {
						@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "LOWRatio" if (@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] eq "PASS");
						print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
					}
				} else {
					@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "LOWDepth" if (@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] eq "PASS");
					print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
				}
			} else {
				@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "NEARIndel" if (@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] eq "PASS");
				print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
			} 
		} else {
			@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] = "NEARSnp" if (@{$snp_vcf_info{$LG_number}{$current_snp_site}}[6] eq "PASS");
			print OUT join ("\t", @{$snp_vcf_info{$LG_number}{$current_snp_site}}) . "\n";
		}
	}
}
close (OUT);
#============================================================================================================================
print "finished\n";




#!/usr/bin/perl

use strict;
use warnings;
#============================================================================================================================
open (INVCFA, "<E:/vcf_filtering/filtered_snp_a.vcf") or die "$!";
open (INVCFB, "<E:/vcf_filtering/filtered_snp_b.vcf") or die "$!";
open (OUT, ">E:/vcf_filtering/stat.txt") or die "$!";
#============================================================================================================================
my %vcf_a_data = ();
my @LG_order = ();
my $LG_number = "00";
while (<INVCFA>) {
	chomp (my $vcf_a_data = $_);
	next if ($vcf_a_data =~ /^#.*/);
	my @vcf_a_data = split (/\t/, $vcf_a_data);
	if ($vcf_a_data[6] eq "PASS") {
		$vcf_a_data{$vcf_a_data[0]}{$vcf_a_data[1]} = "$vcf_a_data[3]_$vcf_a_data[4]";
	}
	if ($vcf_a_data[0] ne $LG_number) {
		push (@LG_order, $vcf_a_data[0]);
		$LG_number = $vcf_a_data[0];
	}
}
close (INVCFA);
#============================================================================================================================
my %vcf_b_data = ();
while (<INVCFB>) {
	chomp (my $vcf_b_data = $_);
	next if ($vcf_b_data =~ /^#.*/);
	my @vcf_b_data = split (/\t/, $vcf_b_data);
	if ($vcf_b_data[6] eq "PASS") {
		$vcf_b_data{$vcf_b_data[0]}{$vcf_b_data[1]} = "$vcf_b_data[3]_$vcf_b_data[4]";
	}
}
close (INVCFB);
#============================================================================================================================
foreach my $LG_number (@LG_order) {
	my @vcf_a_site = ();
	my @vcf_b_site = ();
	my $common_site = 0;
	my $a_specical_site = 0;
	my $b_specical_site = 0;
	my $both_noncommon = 0;
	foreach my $key1 (keys %{$vcf_a_data{$LG_number}}) {
		$vcf_a_site[$key1] = $vcf_a_data{$LG_number}{$key1};
	}
	foreach my $key2 (keys %{$vcf_b_data{$LG_number}}) {
		$vcf_b_site[$key2] = $vcf_b_data{$LG_number}{$key2};
	}
	my $length = ($#vcf_a_site > $#vcf_b_site) ? $#vcf_a_site : $#vcf_b_site;
	for (my $i = 0 ; $i <= $length ; $i++) {
		if ($vcf_a_site[$i]) {
			if ($vcf_b_site[$i]) {
				if ($vcf_a_site[$i] eq $vcf_b_site[$i]) {
					$common_site++;
				} else {
					$both_noncommon++;
				}
			} else {
				$a_specical_site++;
			}
		} else {
			if ($vcf_b_site[$i]) {
				$b_specical_site++;
			}
		}
	}
	print OUT "$LG_number\t$common_site\t$a_specical_site\t$b_specical_site\t$both_noncommon\n";
}
close (OUT);
#============================================================================================================================


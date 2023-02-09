#!/usr/bin/perl

use strict;
use warnings;

open (INAVCF, "<$ARGV[0]") or die "$!";
open (INBVCF, "<$ARGV[1]") or die "$!";
open (OUTAVCF,">$ARGV[2]") or die "$!";
open (OUTBVCF,">$ARGV[3]") or die "$!";

my %vcf_a_data = ();
my $vcf_a_head = ();
while (<INAVCF>) {
	if (my $vcf_a_data =~ /^#.*/) {
		$vcf_a_head .= $vcf_a_data;
		next;
	}
	chomp (my $vcf_a_data = $_);
	my @vcf_a_data = split (/\t/, $vcf_a_data);
	push (@{$vcf_a_data{$vcf_a_data[0]}{"site"}}, $vcf_a_data[1]);
	$vcf_a_data{$vcf_a_data[0]}{$vcf_a_data[1]}{"info"} = $vcf_a_data;
	$vcf_a_data{$vcf_a_data[0]}{$vcf_a_data[1]}{"status"} = $vcf_a_data[6];
}
close (INAVCF);

my %vcf_b_data = ();
my $vcf_b_head = ();
while (<INAVCF>) {
	if (my $vcf_b_data =~ /^#.*/) {
		$vcf_b_head .= $vcf_b_data;
		next;
	}
	chomp (my $vcf_b_data = $_);
	my @vcf_b_data = split (/\t/, $vcf_b_data);
	push (@{$vcf_b_data{$vcf_b_data[0]}{"site"}}, $vcf_b_data[1]);
	$vcf_b_data{$vcf_b_data[0]}{$vcf_b_data[1]}{"info"} = $vcf_b_data;
	$vcf_b_data{$vcf_b_data[0]}{$vcf_b_data[1]}{"status"} = $vcf_b_data[6];
}
close (INBVCF);

print OUTAVCF "$vcf_a_head\n";
my @a_chr_order = keys %vcf_a_data;
foreach my $a_chr_order (@a_chr_order) {
	foreach my $a_snp_site (@{$vcf_a_data{$a_chr_order}{"site"}}) {
		my @comparison_b_snp_site = @{$vcf_b_data{$a_chr_order}{"site"}};
		if ($comparison_b_snp_site[$a_snp_site]) {
			print OUTAVCF "$vcf_a_data{$a_chr_order}{$a_snp_site}{'info'}\n";
		} else {
			if ($vcf_a_data{$a_chr_order}{$a_snp_site}{'status'} eq "PASS") {
				print OUTAVCF "$vcf_a_data{$a_chr_order}{$a_snp_site}{'info'}\n";
			}
		}
	}
}
close (OUTAVCF);

print OUTBVCF "$vcf_b_head\n";
my @b_chr_order = keys %vcf_b_data;
foreach my $b_chr_order (@b_chr_order) {
	foreach my $b_snp_site (@{$vcf_b_data{$b_chr_order}{"site"}}) {
		my @comparison_b_snp_site = @{$vcf_b_data{$b_chr_order}{"site"}};
		if ($comparison_b_snp_site[$b_snp_site]) {
			print OUTBVCF "$vcf_b_data{$b_chr_order}{$b_snp_site}{'info'}\n";
		} else {
			if ($vcf_b_data{$b_chr_order}{$b_snp_site}{'status'} eq "PASS") {
				print OUTBVCF "$vcf_b_data{$b_chr_order}{$b_snp_site}{'info'}\n";
			}
		}
	}
}
close (OUTBVCF);


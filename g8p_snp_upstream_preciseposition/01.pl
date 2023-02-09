#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

open (INVCF,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/AX_S4.bcftools_maf_DP_snp_filter.snpEff.vcf") or die "$!";
open (OUT3,">G:/3.txt") or die "$!";

foreach my $invcf(<INVCF>){
	chomp $invcf;
	next if ($invcf=~/^#.*/);
	my @vcf1=split (/;/,$invcf);
	my @vcf2=split (/\t/,$vcf1[-1]);
	my @vcf3=split (/,/,$vcf2[0]);
	foreach my $vcf3(@vcf3){
		my @vcf4=split(/\|/,$vcf3);
		if ($vcf4[3] eq "CI01099986_00000106_00001564"){
			say OUT3 "$vcf4[3]\t$vcf3";
		}
	}
}

close (INVCF);
close (OUT3);



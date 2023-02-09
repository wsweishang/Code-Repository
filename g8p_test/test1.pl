#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INVCF,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/AX_S4.bcftools_maf_DP_snp_filter.snpEff.vcf") or die "$!";
open (OUT7,">G:/7.txt") or die "$!";

my %check=();
my %hash=();

foreach my $invcf1(<INVCF>){
	chomp $invcf1;
	next if ($invcf1=~/^#.*/);
	my @vcf1=split (/;/,$invcf1);
	my @vcf2=split (/\t/,$vcf1[-1]);
	my @vcf3=split (/,/,$vcf2[0]);
	foreach my $vcf3(@vcf3){
		my @vcf4=split(/\|/,$vcf3);
#		next unless ($vcf4[4]);
		next if ($vcf4[4]=~/.*circ$/);
		if ($vcf4[1] eq "upstream_gene_variant"){
			$check{$vcf4[3]}="exist";
		}
#		undef @vcf4;
	}
	foreach my $key(keys %check){
		$hash{$key}++;
	}
	undef %check;
#	undef @vcf1;
#	undef @vcf2;
#	undef @vcf3;
}
say OUT7 Dumper (\%hash);


#foreach my $k1(keys %hash){
#	if ($comp{$k1}){
#		if ($hash{$k1} == $comp{$k1}){
#			say OUT7 "$k1\t$hash{$k1}\t$comp{$k1}";
#		}else{
#			say OUT7 "uneq\t$k1\t$hash{$k1}\t$comp{$k1}";
#		}
#	}else{
#		say OUT7 "error\t$k1\t$comp{$k1}";
#	}
#}

close (INVCF);
close (OUT7);





#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INVCF,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/AX_S4.bcftools_maf_DP_snp_filter.snpEff.vcf") or die "$!";
open (INTXT,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/AX_S4_snp_snpEff_genes.txt") or die "$!";
open (OUT1,">G:/1.txt") or die "$!";
open (OUT2,">G:/2.txt") or die "$!";

my %check=();
my %hash=();
foreach my $invcf(<INVCF>){
	chomp $invcf;
	next if ($invcf=~/^#.*/);
	my @vcf1=split (/;/,$invcf);
	my @vcf2=split (/\t/,$vcf1[-1]);
	my @vcf3=split (/,/,$vcf2[0]);
	my @vcf4=();
	foreach my $vcf3(@vcf3){
		@vcf4=split(/\|/,$vcf3);
		next unless ($vcf4[4]);
		next if ($vcf4[4]=~/.*circ$/);
		if ($vcf4[1] eq "upstream_gene_variant"){
			$check{$vcf4[3]}="exist";
		}
	}
	foreach my $key(keys %check){
		$hash{$key}++;
	}
	undef %check;
}
say OUT1 Dumper (\%hash);
foreach my $intxt(<INTXT>){
	chomp $intxt;
	next if ($intxt=~/^#.*/);
	my @txt=split (/\t/,$intxt);
	next if ($txt[1]=~/.*circ$/);
	if (exists $hash{$txt[0]}){
		if ($txt[-1]!=$hash{$txt[0]}){
			say OUT2 $intxt;
		}
	}
}



#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INVCF,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/AX_S4.bcftools_maf_DP_snp_filter.snpEff.vcf") or die "$!";
open (INTXT,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/AX_S4_snp_snpEff_genes.txt") or die "$!";
open (OUT8,">G:/8.txt") or die "$!";

my %comp=();
foreach my $invcf2(<INVCF>){
	chomp $invcf2;
	next if ($invcf2=~/^#.*/);
	my @vcf5=split (/;/,$invcf2);
	my @vcf6=split (/\t/,$vcf5[-1]);
	my @vcf7=split (/,/,$vcf6[0]);
	foreach my $vcf7(@vcf7){
		my @vcf8=split(/\|/,$vcf7);
#		next unless ($vcf8[4]);
		next if ($vcf8[4]=~/.*circ$/);
		if ($vcf8[1] eq "upstream_gene_variant"){
			$comp{$vcf8[3]}++;
		}
	}
}
#say OUT8 Dumper (\%comp);
foreach my $intxt(<INTXT>){
	chomp $intxt;
	next if ($intxt=~/^#.*/);
	my @txt=split (/\t/,$intxt);
	next if ($txt[1]=~/.*circ$/);
	if (exists $comp{$txt[0]} and $comp{$txt[0]}==$txt[-1]){
		next ;
	}elsif ($txt[-1]==0){
		next;
	}else{
		say OUT8 "$txt[0]\t$txt[-1]\t$comp{$txt[0]}";
	}
}


close (INVCF);
close (INTXT);
close (OUT8);


#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INVCF,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/AX_S4.bcftools_maf_DP_snp_filter.snpEff.vcf") or die "$!";
open (INGFF,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/C_idella_female_genemodels.v1.gmap.gff") or die "$!";
open (OUT10,">G:/10.txt") or die "$!";

my %hash=();
foreach my $ingff(<INGFF>){
	chomp $ingff;
	my @gff=split(/[\t|=]/,$ingff);
	if ($gff[2] eq "gene"){
		$hash{$gff[0]}{$gff[-1]}="$gff[3]\t$gff[4]";
	}
}

foreach my $invcf(<INVCF>){
	chomp $invcf;
	next if ($invcf=~/^#.*/);
	my @vcf1=split (/;/,$invcf);
	my @vcf2=split (/\t/,$vcf1[-1]);
	my @vcf3=split (/,/,$vcf2[0]);
	foreach my $vcf3(@vcf3){
		my @vcf4=split(/\|/,$vcf3);
		next if ($vcf4[4]=~/.*circ$/);
		my @snp=split (/\t/,$invcf);
		my @vcf5=split(/_/,$vcf4[3]);
		if ($vcf4[1] eq "upstream_gene_variant"){
			if (exists $hash{$snp[0]}{$vcf4[3]}){
				if ($snp[0] eq $vcf5[0]){
					my @gene_site=split(/\t/,$hash{$snp[0]}{$vcf4[3]});
					my $length1=$snp[1]-$gene_site[0];
					my $length2=$gene_site[1]-$snp[1];
					if ($length1 > $length2 and $length2 >= -5000){
						say OUT10 "$vcf4[3]\t$snp[1]\t$length2";
					}elsif (-5000 <= $length1 and $length1 < $length2){
						say OUT10 "$vcf4[3]\t$snp[1]\t$length1";
					}else{
						say "ERROR!$vcf4[3]\t$snp[1]\t$length1\t$length2";
					}
				}
			}else{
				say "ERROR!";
			}	
		}
	}
}

close (INVCF);
close (INGFF);
close (OUT10);



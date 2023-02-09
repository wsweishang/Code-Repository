#!/usr/bin/perl -w

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INGFF,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/C_idella_female_genemodels.v1.gmap.gff") or die "$!";
open (OUT2,">G:/2.txt") or die "$!";

#my $CDS_site=();
#my $gene_left_site=();
#my $gene_right_site=();
#my %hash=();
#
#foreach my $ingff(<INGFF>){
#	chomp $ingff;
#	my @gff=split(/\t/,$ingff);
#	if ($gff[2] eq "gene"){
#		$gene_left_site=$gff[3];
#		$gene_right_site=$gff[4];
#	}
#	if ($gff[2] eq "CDS"){
#		$hash{$gff[0]}{"$gene_left_site\t$gene_right_site"}=$hash{$gff[0]}{"$gene_left_site\t$gene_right_site"}."\t".$gff[3]."\t".$gff[4];
#	}
#}
#
#foreach my $k1(keys %hash){
#	foreach my $k2(keys %{$hash{$k1}}){
#		my @sort_value=split(/\t/,$hash{$k1}{$k2});
#		my @sort_key=split(/\t/,$k2);
#		
#		@sort_value=sort {$a <=> $b} @sort_value;
#		shift @sort_value;
#		say OUT2 "$k1=>$k2=>@sort_value";
#		@sort_key=sort {$a <=> $b} @sort_key;
#		if ($sort_key[0] != $sort_value[0]){
##			say OUT2 "$k1=>$k2=>@sort_value";
#			say OUT2 "1";
#		}elsif ($sort_key[-1] != $sort_value[-1]){
##			say OUT2 "$k1=>$k2=>@sort_value";
#			say OUT2 "2";
#		}
#	}
#}
#say OUT2 Dumper (\%hash);





foreach my $ingff(<INGFF>){
	chomp $ingff;
	my @gff=split(/[\t|=]/,$ingff);
	if ($gff[2] eq "gene"){
		say OUT2 "$gff[-1]";
	}
}


close (INGFF);
close (OUT2);


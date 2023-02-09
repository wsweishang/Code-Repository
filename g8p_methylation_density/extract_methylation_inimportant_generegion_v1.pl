#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INGFF,"<G:/grasscarp_8populations/manuscript/Scaffold/C_idella_female_genemodels.v1.gmap_changedposition_LG_v2.gff") or die "$!";
my %gff=();
my $ID=();
foreach my $gff(<INGFF>){
	chomp $gff;
	my @gff=split(/\t/,$gff);
	if ($gff[2] eq "gene"){
		$gff=~/Name=([0-9a-zA-Z_]+)$/;
		$ID=$1;
	}elsif ($gff[2] eq "exon"){
		if ($gff[6] eq "+"){
			push (@{$gff{$ID}},"$gff[3]\t$gff[4]");
		}elsif ($gff[6] eq "-"){
			unshift (@{$gff{$ID}},"$gff[3]\t$gff[4]");
		}
	}
}
close (INGFF);

my %gene_region=();
my %check_gene=();
foreach my $key(keys %gff){
	my @key=split (/\_/,$key);
	my $firstexon=shift @{$gff{$key}};
	my @firstexon=split(/\t/,$firstexon);
	my $promoter_start=$firstexon[0]-1500;
	my $promoter_end=$firstexon[0]-501;
	my $UTR_start=$firstexon[0]-500;
	my $UTR_end=$firstexon[0]-1;
	$gene_region{$key[0]}{"$firstexon"}="$key\tfirstexon";
	$gene_region{$key[0]}{"$promoter_start\t$promoter_end"}="$key\tpromoter";
	$gene_region{$key[0]}{"$UTR_start\t$UTR_end"}="$key\t5UTR";
	
	push (@{$check_gene{$key[0]}},$firstexon);
	push (@{$check_gene{$key[0]}},"$promoter_start\t$promoter_end");
	push (@{$check_gene{$key[0]}},"$UTR_start\t$UTR_end");
	
	if (@{$gff{$key}}){
		my $secondexon=shift @{$gff{$key}};
		my @secondexon=split(/\t/,$secondexon);
		my $firstintron_start=$firstexon[1]+1;
		my $firstintron_end=$secondexon[0]-1;
		$gene_region{$key[0]}{"$secondexon"}="$key\tsecondexon";
		$gene_region{$key[0]}{"$firstintron_start\t$firstintron_end"}="$key\tfirstintron";
		
		push (@{$check_gene{$key[0]}},$secondexon);
		push (@{$check_gene{$key[0]}},"$firstintron_start\t$firstintron_end");
	}
}

#open (INFILENAMELIST,"<") or die "$!";
my %methylation=();
my %check_methylation=();
#foreach my $infilenamelist(<INFILENAMELIST>){
#	chomp $infilenamelist;
	open (INMETHYLATIONTXT,"<G:/1.txt") or die "$!";
	foreach my $methylation(<INMETHYLATIONTXT>){
		chomp $methylation;
		my @methylation=split(/\t/,$methylation);
		if ($methylation[-1] eq "methylated"){
			$methylation{$methylation[0]}{$methylation[1]}="$methylation";
			push (@{$check_methylation{$methylation[0]}},$methylation[1]);
		}
	}
#}

my %data=();
foreach my $key(keys %check_gene){
	foreach my $startend(@{$check_gene{$key}}){
		my @startend=split(/\t/,$startend);
		foreach my $methylation_site(@{$check_methylation{$key}}){
			if ($startend[0] <= $methylation_site && $startend[1] >= $methylation_site){
				$data{$key}{$startend}="$gene_region{$key}{$startend}\t$methylation{$key}{$methylation_site}";
			}
#			else {
#				$data{$key}{$startend}="$gene_region{$key}{$startend}\t$methylation{$key}{$methylation_site}";
#			}
		}
		
		
		
	}
}




















open (OUT,">G:/test.txt") or die "$!";

#say OUT Dumper (\%check_gene);
#say OUT Dumper (\%check_methylation);
say OUT Dumper (\%data);

close (OUT);

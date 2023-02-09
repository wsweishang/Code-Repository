#!/usr/bin/perl

use strict;
use warnings;

open (INGFF,"</home/yinglu/grasscarp_reseq_8populations/linkage_groups/C_idella_female_genemodels.v1.gmap_changedposition_LG_v2.gff") or die "$!";
open (INMETHYLATIONTXT,"<$ARGV[0]") or die "$!";
open (OUT,">$ARGV[1]") or die "$!";

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

my %gene_information_region=();
my %check_gene=();
foreach my $key(keys %gff){
	my @key=split (/\_/,$key);
	my $firstexon=shift @{$gff{$key}};
	my @firstexon=split(/\t/,$firstexon);
	my $promoter_start=$firstexon[0]-1500;
	my $promoter_end=$firstexon[0]-501;
	my $UTR_start=$firstexon[0]-500;
	my $UTR_end=$firstexon[0]-1;
	$gene_information_region{$key[0]}{"$firstexon"}="$key\tfirstexon";
	$gene_information_region{$key[0]}{"$promoter_start\t$promoter_end"}="$key\tpromoter";
	$gene_information_region{$key[0]}{"$UTR_start\t$UTR_end"}="$key\t5UTR";
	
	push (@{$check_gene{$key[0]}},$firstexon);
	push (@{$check_gene{$key[0]}},"$promoter_start\t$promoter_end");
	push (@{$check_gene{$key[0]}},"$UTR_start\t$UTR_end");
	
	if (@{$gff{$key}}){
		my $secondexon=shift @{$gff{$key}};
		my @secondexon=split(/\t/,$secondexon);
		my $firstintron_start=$firstexon[1]+1;
		my $firstintron_end=$secondexon[0]-1;
		$gene_information_region{$key[0]}{"$secondexon"}="$key\tsecondexon";
		$gene_information_region{$key[0]}{"$firstintron_start\t$firstintron_end"}="$key\tfirstintron";
		
		push (@{$check_gene{$key[0]}},$secondexon);
		push (@{$check_gene{$key[0]}},"$firstintron_start\t$firstintron_end");
	}
}

my %methylation_information=();
my %check_methylation=();
foreach my $methylation(<INMETHYLATIONTXT>){
	chomp $methylation;
	my @methylation=split(/\t/,$methylation);
	if ($methylation[-1] eq "methylated"){
		$methylation_information{$methylation[0]}{$methylation[1]}="$methylation";
		push (@{$check_methylation{$methylation[0]}},$methylation[1]);
	}
}
close (INMETHYLATIONTXT);

my %data=();
foreach my $chr(keys %check_gene){
	foreach my $startend(@{$check_gene{$chr}}){
		my @startend=split(/\t/,$startend);
		foreach my $methylation_site(@{$check_methylation{$chr}}){
			if ($startend[0] <= $methylation_site && $startend[1] >= $methylation_site){
				$data{$chr}{$startend}="$methylation_information{$chr}{$methylation_site}\t$gene_information_region{$chr}{$startend}";
			}
		}
	}
}

print OUT "chromsome\tposition\tstrand\tmethyl_count\tunmethyl_count\tcontext\ttri_context\tfdr\tmethyl_status\tGeneID\tregion\n";
foreach my $chrid(sort {$a <=> $b} keys %data){
	foreach my $range(sort {$a <=> $b} keys %{$data{$chrid}}){
		print OUT "$data{$chrid}{$range}\n";
	}
}
close (OUT);

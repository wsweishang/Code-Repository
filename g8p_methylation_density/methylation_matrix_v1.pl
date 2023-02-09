#!/usr/bin/perl

use strict;
use warnings;
use Math::BigFloat;

open (INGFF,"<G:/1/C_idella_female_genemodels.v1.gmap_changedposition_LG_v2.gff") or die "$!";
open (INDMRFILES,"<G:/1/filenamelist.txt") or die "$!";
open (OUT,">G:/1/g8p_methylation_heatmap_23files_matrix_v1.txt") or die "$!";

my %gff=();
my $ID=();
my @geneorder=();
foreach my $gff(<INGFF>){
	chomp $gff;
	my @gff=split(/\t/,$gff);
	if ($gff[2] eq "gene"){
		$gff=~/Name=([0-9a-zA-Z_]+)$/;
		$ID=$1;
		push (@geneorder,$ID);
	}elsif ($gff[2] eq "exon"){
		if ($gff[6] eq "+"){
			push (@{$gff{$ID}},"$gff[3]\t$gff[4]");
		}elsif ($gff[6] eq "-"){
			unshift (@{$gff{$ID}},"$gff[3]\t$gff[4]");
		}
	}
}
close (INGFF);
print "1\n";

my %gene_region=();
my @regionorder=qw/promoter 5UTR firstexon firstintron secondexon/;
foreach my $key(keys %gff){
	my @key=split (/\_/,$key);
	my $firstexon=shift @{$gff{$key}};
	my @firstexon=split(/\t/,$firstexon);
	my $promoter_start=$firstexon[0]-1500;
	my $promoter_end=$firstexon[0]-501;
	my $UTR_start=$firstexon[0]-500;
	my $UTR_end=$firstexon[0]-1;
	$gene_region{$key[0]}{$firstexon[0]}{$firstexon[1]}="$key\tfirstexon";
	$gene_region{$key[0]}{$promoter_start}{$promoter_end}="$key\tpromoter";
	$gene_region{$key[0]}{$UTR_start}{$UTR_end}="$key\t5UTR";
	if (@{$gff{$key}}){
		my $secondexon=shift @{$gff{$key}};
		my @secondexon=split(/\t/,$secondexon);
		my $firstintron_start=$firstexon[1]+1;
		my $firstintron_end=$secondexon[0]-1;
		$gene_region{$key[0]}{$secondexon[0]}{$secondexon[1]}="$key\tsecondexon";
		$gene_region{$key[0]}{$firstintron_start}{$firstintron_end}="$key\tfirstintron";
	}
}
print "2\n";

my %dmr=();
my @fileorder=();
foreach my $filename(<INDMRFILES>){
	chomp $filename;
	$filename=~/\/([A-Z]{2}_vs_[A-Z]{2})/;
	my $fileID=$1;
	push (@fileorder,$fileID);
	open (IN,"<$filename");
	foreach my $dmr(<IN>){
		chomp $dmr;
		my @dmr=split(/\t/,$dmr);
		if (exists $gene_region{$dmr[0]}){
			my $start=$dmr[1]+1;
			my $end=$dmr[2]+1;
			foreach my $key2(keys %{$gene_region{$dmr[0]}}){
				foreach my $key3(keys %{$gene_region{$dmr[0]}{$key2}}){
					if ($key2<=$start and $key3>=$end){
						my $i=new Math::BigFloat $dmr[-1];
						my ($geneID,$region)=(split (/\t/,$gene_region{$dmr[0]}{$key2}{$key3}))[0,1];
						$dmr{$geneID}{$fileID}{$region}+=$i;
					}
				}
			}
		}
	}
}
print "3\n";

print OUT "\t",join("\t\t\t\t\t",@fileorder),"\n",("\t",join("\t",@regionorder)) x23,"\n";
foreach my $geneorder(@geneorder){
	print OUT "$geneorder\t";
	foreach my $fileorder(@fileorder){
		foreach my $regionorder(@regionorder){
			if (exists $dmr{$geneorder}{$fileorder}{$regionorder}){
				print OUT "$dmr{$geneorder}{$fileorder}{$regionorder}\t";
			}else {
				print OUT "NA\t";
			}
		}
	}
	print OUT "\n";
}
print "4\n";

#foreach my $key1(sort {$a cmp $b} keys %dmr){
#	foreach my $key2(keys %{$dmr{$key1}}){
#		foreach my $key3(keys %{$dmr{$key1}{$key2}}){
#			print OUT "$key1 => $key2 => $key3 => $dmr{$key1}{$key2}{$key3}\n";
#		}
#		
#	}
#}
#print "4\n";
close (INDMRFILES);
close (IN);
close (OUT);


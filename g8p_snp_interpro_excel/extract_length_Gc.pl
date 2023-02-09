#!/usr/bin/perl

use strict;
use warnings;
#use Data::Dumper;

#mkdir ("G:/result") or die "$!";
open (INFASTA,"<G:/grasscarp_8populations/manuscript/Scaffold/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.txt") or die "$!";
open (INGFF,"<G:/grasscarp_8populations/manuscript/Scaffold/C_idella_female_genemodels.v1.gmap_changedposition_LG_v2.gff") or die "$!";
open (OUTFASTA,">G:/result/2.fasta") or die "$!";
open (OUTLIST,">G:/result/gc_length_list.txt") or die "$!";

my %hash=();
my @files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";
foreach my $file(@files){
	open (INCOMPARED,"<$file") or die "$!";
	foreach my $content(<INCOMPARED>){
		chomp $content;
		next if ($content=~/^#.*/);
		my @content_splited=split(/\t/,$content);
		next if ($content_splited[1]=~/.*circ$/);
		$hash{$content_splited[0]}="NA";
	}
}

foreach my $gff(<INGFF>){
	chomp $gff;
	my @gff=split (/\t/,$gff);
	if ($gff[2] eq "gene"){
		my @fh=split (/=/,$gff);
		if (exists $hash{$fh[-1]}){
			$hash{$fh[-1]}="$gff[0]\t$gff[3]\t$gff[4]";
		}
	}
}
#print OUT Dumper (\%hash);

my $LG=();
my %fasta=();
foreach my $fasta(<INFASTA>){
	chomp $fasta;
	if ($fasta=~/^>LG[0]*[0-9]+/){
		$fasta=~s/^>LG[0]*([0-9]+)/$1/g;
		$LG="LG".$fasta;
	}elsif ($fasta=~/^[A-Z]{100}/){
		$fasta{$LG}="$fasta";
	}	
}
#print OUT Dumper (\%fasta);

my %sequence=();
my %length=();
foreach my $key(keys %hash){
	next if ($hash{$key} eq "NA");
	my @value=split (/\t/,$hash{$key});
	my $start=$value[1]-1;
	my $length=$value[2]-($value[1]-1);
	$sequence{$key}=substr($fasta{$value[0]},$start,$length);
	$length{$key}=$length;
#	$sequence{$key}=substr($fasta{$value[0]},$value[1]-1,$value[2]-($value[1]-1));
}
#print OUT Dumper (\%sequence);

foreach my $k(keys %sequence){
	print OUTFASTA ">$k\n";
	print OUTFASTA "$sequence{$k}\n";
}
foreach my $f(keys %length){
	print OUTLIST ">$f $length{$f}\n";
}

close (INCOMPARED);
close (INFASTA);
close (INGFF);
close (OUTFASTA);
close (OUTLIST);

#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (OUTFASTA,">G:/C_idella_female_genemodels.v1.aa_extracted_snpGene.fasta") or die "$!";
open (OUTLENGTH,">G:/C_idella_female_genemodels.v1.aa_extracted_snpGene.fasta_length.txt") or die "$!";
open (INFASTA,"<G:/C_idella_female_genemodels.v1.aa") or die "$!";

my %hash_order=();
my @files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";
foreach my $file(@files){
	open (INTXT,"<$file") or die "$!";
	foreach my $content(<INTXT>){
		chomp $content;
		next if ($content=~/^#.*/);
		my @content_splited=split(/\t/,$content);
		next if ($content_splited[1]=~/.*circ$/);
		$hash_order{$content_splited[0]}="1";
	}
}

my %hash_fasta=();
my $ID=();
foreach my $fasta(<INFASTA>){
	chomp $fasta;
	if ($fasta=~s/^>(CI[a-zA-Z0-9_]+)\s[0-9]+\s[a-zA-Z]+/$1/){
		$ID=$1;
	}else{
		$hash_fasta{$ID}=$fasta;
	}
}

foreach my $key(keys %hash_order){
	if (exists $hash_fasta{$key}){
		my $length=length $hash_fasta{$key};
		print OUTFASTA ">$key\n";
		print OUTFASTA "$hash_fasta{$key}\n";
		print OUTLENGTH ">$key $length\n";
	}else {
		print "error:$key\n";
	}
}

#print OUTFASTA Dumper (\%hash_fasta);

close (INFASTA);
close (INTXT);
close (OUTFASTA);
close (OUTLENGTH);






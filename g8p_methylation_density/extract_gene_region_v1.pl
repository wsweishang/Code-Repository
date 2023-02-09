#!/usr/bin/perl

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

open (OUT,">G:/1.txt") or die "$!";
foreach my $key(sort {$a cmp $b} keys %gff){
	my @key=split (/\_/,$key);
	my $firstexon=shift @{$gff{$key}};
	my @firstexon=split(/\t/,$firstexon);
	my $promoter_start=$firstexon[0]-1500;
	my $promoter_end=$firstexon[0]-501;
	my $UTR_start=$firstexon[0]-500;
	my $UTR_end=$firstexon[0]-1;
	print OUT "$key[0]\t$promoter_start\t$promoter_end\t$key\tpromoter\t\n";
	print OUT "$key[0]\t$UTR_start\t$UTR_end\t$key\t5'UTR\t\n";
	print OUT "$key[0]\t$firstexon\t$key\tfirstexon\t\n";
	
	if (@{$gff{$key}}){
		my $secondexon=shift @{$gff{$key}};
		my @secondexon=split(/\t/,$secondexon);
		my $firstintron_start=$firstexon[1]+1;
		my $firstintron_end=$secondexon[0]-1;
		print OUT "$key[0]\t$firstintron_start\t$firstintron_end\t$key\tfirstintron\t\n";
		print OUT "$key[0]\t$secondexon\t$key\tsecondexon\t\n";
	}
}

#print OUT Dumper (\%gff);
close (OUT);



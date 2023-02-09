#!/usr/bin/perl

use strict;
use warnings;

open (INFILENAMELIST,"<$ARGV[0]") or die "$!";
open (INAAFASTA,"<C_idella_female_genemodels.v1.aa") or die "$!";
open (OUT,">$ARGV[0]") or die "$!";
open (OUTERROR,">$ARGV[1].error") or die "$!";

my @filenamelist=();
foreach my $filename(<INFILENAMELIST>){
	chomp $filename;
	push (@filenamelist,$filename);
}

my %check=();
my %compare=();
foreach my $filename_a(@filenamelist){
	open (INFILEA,"<$filename_a") or die "$!";
	foreach my $file_a(<INFILEA>){
		chomp $file_a;
		next if ($file_a=~/^#.*/);
		my @file_a_splited=split (/\t/,$file_a);
		next if ($file_a_splited[1]=~/.*circ$/);
		$compare{$file_a_splited[0]}="NA";
	}
	foreach my $filename_b(@filenamelist){
		next if ($filename_a eq $filename_b);
		open (INFILEB,"<$filename_b") or die "$!";
		foreach my $file_b(<INFILEB>){
			chomp $file_b;
			next if ($file_b=~/^#.*/);
			my @file_b_splited=split (/\t/,$file_b);
			next if ($file_b_splited[1]=~/.*circ$/);
			unless (exists $compare{$file_b_splited[0]}){
				$check{$file_b_splited[0]}="y";
			}
		}
	}
	undef %compare;
}
close (INFILENAMELIST);

my $ID=();
my %aafasta=();
foreach my $aafasta(<INAAFASTA>){
	chomp $aafasta;
	if ($aafasta=~/^>(CI[a-zA-Z0-9_]+)\s[0-9]+\s[a-zA-Z]+/){
		$ID=$1;
	}else {
		$aafasta{$ID}=$aafasta;
	}
}
close (INAAFASTA);

foreach my $key(keys %check){
	if (exists $aafasta{$key}){
		print OUT ">$key\n";
		print OUT "$aafasta{$key}\n";
	}else {
		print OUTERROR "$key\n";
	}
	
}

close (OUT);
close (OUTERROR);


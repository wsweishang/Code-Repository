#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use File::Basename;

my %data=();
my @files = glob "G:/manuscript/*.txt";

foreach my $file(@files){
	my $file_name = basename ($file,".txt");
	next if ($file_name eq "AX_S4_indels_snpEff_genes");
	say $file_name;
	open (IN,"<$file") or die "$!";
	open (OUT,">>G:/1.txt") or die "$!";
	foreach my $fh(<IN>){
		print OUT $fh;
	}
	close (IN);
	close (OUT);
}









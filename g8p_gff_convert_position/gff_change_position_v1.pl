#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INGFF,"<G:/grasscarp_8populations/manuscript/Scaffold/C_idella_female_genemodels.v1.gmap.gff");
open (INTXT,"<G:/grasscarp_8populations/result/Scaffold/Cid_AnchorLGmapNew_0624_263scafford_out.txt");
open (OUT,">>G:/1.txt");

my @ingff=<INGFF>;
my @intxt=<INTXT>;

my %txt=();

foreach my $intxt(@intxt){
	chomp $intxt;
	next unless ($intxt=~/^[0-9]/);
	my @txt=split(/\t/,$intxt);
	$txt{$txt[1]}= $txt[3];
}
close (INGFF);
close (INTXT);


foreach my $ingff(@ingff){
	chomp $ingff;
	my @gff=split(/\t/,$ingff);
	next unless (exists $txt{$gff[0]});
	$gff[3] = ($txt{$gff[0]} + $gff[3]) - 1;
	$gff[4] = ($txt{$gff[0]} + $gff[4]) - 1;
	say OUT "$gff[0]\t$gff[1]\t$gff[2]\t$gff[3]\t$gff[4]\t$gff[5]\t$gff[6]\t$gff[7]\t$gff[8]";
}
#say Dumper (\%txt);





























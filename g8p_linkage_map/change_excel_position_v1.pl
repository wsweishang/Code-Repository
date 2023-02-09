#!/usr/bin/perl

use strict;
use warnings;

open (INEXCEL,"<G:/excel.txt") or die "$!";
open (INTXT,"<G:/Cid_AnchorLGmapNew_0624_263scafford_out_v2.txt") or die "$!";
open (OUT,">G:/changed_position_linkagemap_LGlabel_excel_v1.txt") or die "$!";

my $title=();
my %excel=();
foreach my $inexcel(<INEXCEL>){
	chomp $inexcel;
	if ($inexcel=~/^LG.*/){
		$title=$inexcel;
		next;
	}
	
	my @inexcel=split(/\t/,$inexcel);
	push (@{$excel{$inexcel[2]}},$inexcel);
}
close (INEXCEL);

print OUT "$title\n";
foreach my $intxt(<INTXT>){
	chomp $intxt;
	next if ($intxt=~/^LG.*/);
	my @intxt=split (/\t/,$intxt);
	foreach my $excel(@{$excel{$intxt[1]}}){
		my @excel=split (/\t/,$excel);
		if ($intxt[-1] eq "+"){
			$excel[3]=$excel[3]+$intxt[3]-1;
			print OUT join ("\t",@excel),"\n";
		}elsif ($intxt[-1] eq "-"){
			$excel[3]=($intxt[2]-$excel[3])+$intxt[3];
			print OUT join ("\t",@excel),"\n";
		}
	}
}
close (INTXT);
close (OUT);



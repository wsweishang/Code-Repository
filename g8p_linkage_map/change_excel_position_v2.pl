#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INEXCEL,"<G:/1.txt") or die "$!";
open (INTXT,"<G:/Cid_AnchorLGmapNew_0624_263scafford_out_v2.txt") or die "$!";
open (OUT,">G:/LG_1-24_Dist_1-24_with_zero.txt") or die "$!";

my %order=();
foreach my $intxt(<INTXT>){
	chomp $intxt;
	next if ($intxt=~/^LG.*/);
	my @intxt=split (/\t/,$intxt);
	$order{$intxt[1]}{"LG"}=$intxt[0];
	$order{$intxt[1]}{"length"}=$intxt[2];
	$order{$intxt[1]}{"startsite"}=$intxt[3];
	$order{$intxt[1]}{"orientation"}=$intxt[4];
}
close (INTXT);
#say OUT Dumper (\%order);

my %excel=();
foreach my $inexcel(<INEXCEL>){
	chomp $inexcel;
	next if ($inexcel=~/^LG.*/);
	my @inexcel=split(/\t/,$inexcel);
	if ($order{$inexcel[2]}{"orientation"} eq "+"){
		$inexcel[3]=($order{$inexcel[2]}{"startsite"}+$inexcel[3]-1)/1000000;
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"}=$inexcel[3];
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"lgcm"}=$inexcel[4];
	}elsif ($order{$inexcel[2]}{"orientation"} eq "-"){
		$inexcel[3]=(($order{$inexcel[2]}{"length"}-$inexcel[3])+$order{$inexcel[2]}{"startsite"})/1000000;
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"}=$inexcel[3];
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"lgcm"}=$inexcel[4];
	}
}
close (INEXCEL);
#say OUT Dumper (\%excel);

my $fh="A";
foreach my $key1(sort {$a <=> $b} keys %excel){
	print OUT "$key1\t0\t$fh\n";
	$fh++;
	foreach my $key2(sort {$excel{$key1}{$a}{"scaffold"} <=> $excel{$key1}{$b}{"scaffold"}} keys %{$excel{$key1}}){
		print OUT "$key1\t$excel{$key1}{$key2}{'lgcm'}\t$key2\n";
	}
}

my $gh="a";
foreach my $key1(sort {$a <=> $b} keys %excel){
	print OUT "Physical$key1\t0\t$gh\n";
	$gh++;
	foreach my $key2(sort {$excel{$key1}{$a}{"scaffold"} <=> $excel{$key1}{$b}{"scaffold"}} keys %{$excel{$key1}}){
		print OUT "Physical$key1\t$excel{$key1}{$key2}{'scaffold'}\t$key2\n";
	}
}





close (OUT);



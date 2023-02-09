#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (INEXCEL,"<G:/1.txt") or die "$!";
open (INTXT,"<G:/Cid_AnchorLGmapNew_0624_263scafford_out_v2.txt") or die "$!";
open (OUTDATAFRAME,">G:/grasscarp_8populations/g8p_linkage_map/LG_1-24_Dist_1-24_with_zero_v2.txt") or die "$!";
open (OUTCOLFRAME,">G:/grasscarp_8populations/g8p_linkage_map/LG_1-24_Dist_1-24_with_zero_col_v2.txt") or die "$!";

my $first_LG=1;
my $i=-1;
my %order=();
my %col=();
foreach my $intxt(<INTXT>){
	chomp $intxt;
	next if ($intxt=~/^LG.*/);
	my @intxt=split (/\t/,$intxt);
	$order{$intxt[1]}{"LG"}=$intxt[0];
	$order{$intxt[1]}{"length"}=$intxt[2];
	$order{$intxt[1]}{"startsite"}=$intxt[3];
	$order{$intxt[1]}{"orientation"}=$intxt[4];
	$i++;
	if ($first_LG!=$intxt[0]){
		$i=0;
	}
	$order{$intxt[1]}{"interval"}=$i*500000;
	$first_LG=$intxt[0];
	$col{$intxt[1]}{"start"}=($intxt[3]+$order{$intxt[1]}{"interval"})/500000;
	$col{$intxt[1]}{"end"}=($intxt[3]+$intxt[2]+$order{$intxt[1]}{"interval"})/500000;
	my $ggg=$col{$intxt[1]}{"end"}-$col{$intxt[1]}{"start"};
	if ($ggg <= 1){
		$col{$intxt[1]}{"start"}=$col{$intxt[1]}{"start"}-0.2;
		$col{$intxt[1]}{"end"}=$col{$intxt[1]}{"end"}+0.2;
	}
}
close (INTXT);

my %excel=();
foreach my $inexcel(<INEXCEL>){
	chomp $inexcel;
	next if ($inexcel=~/^LG.*/);
	my @inexcel=split(/\t/,$inexcel);
	if ($order{$inexcel[2]}{"orientation"} eq "+"){
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"}=($order{$inexcel[2]}{"startsite"}+$inexcel[3]-1+$order{$inexcel[2]}{"interval"})/500000;
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"lgcm"}=$inexcel[4];
	}elsif ($order{$inexcel[2]}{"orientation"} eq "-"){
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"}=(($order{$inexcel[2]}{"length"}-$inexcel[3])+$order{$inexcel[2]}{"startsite"}+$order{$inexcel[2]}{"interval"})/500000;
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"lgcm"}=$inexcel[4];
	}
	
}
close (INEXCEL);

print OUTDATAFRAME "LG\tPosition\tSNP\nspecial1\t0\t01\nspecial1\t50\t02\nspecial2\t0\t03\nspecial2\t50\t04\nspecial3\t0\t05\nspecial3\t50\t06\n";
my $fh="A";
foreach my $key1(sort {$a <=> $b} keys %excel){
	print OUTDATAFRAME "$key1\t0\t$fh\n";
	$fh++;
	foreach my $key2(sort {$excel{$key1}{$a}{"scaffold"} <=> $excel{$key1}{$b}{"scaffold"}} keys %{$excel{$key1}}){
		print OUTDATAFRAME "$key1\t$excel{$key1}{$key2}{'lgcm'}\t$key2\n";
	}
}

my $gh="a";
foreach my $key1(sort {$a <=> $b} keys %excel){
	print OUTDATAFRAME "Physical$key1\t0\t$gh\n";
	$gh++;
	foreach my $key2(sort {$excel{$key1}{$a}{"scaffold"} <=> $excel{$key1}{$b}{"scaffold"}} keys %{$excel{$key1}}){
		print OUTDATAFRAME "Physical$key1\t$excel{$key1}{$key2}{'scaffold'}\t$key2\n";
	}
}
close (OUTDATAFRAME);

print OUTCOLFRAME "chr\ts\te\tcol\n";
foreach my $key(keys %col){
	print OUTCOLFRAME "Physical$order{$key}{'LG'}\t$col{$key}{'start'}\t$col{$key}{'end'}\torange\n"
}
close (OUTCOLFRAME);


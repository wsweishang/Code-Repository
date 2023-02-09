#!/usr/bin/perl

use strict;
use warnings;

open (INEXCEL,"<G:/1.txt") or die "$!";
open (INTXT,"<G:/Cid_AnchorLGmapNew_0624_263scafford_out_v2.txt") or die "$!";
open (OUTDATAFRAME,">G:/LG_1-24_Dist_1-24_with_zero_v2.txt") or die "$!";
open (OUTCOLFRAME,">G:/LG_1-24_Dist_1-24_with_zero_col_v2.txt") or die "$!";

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
	$i=0 if ($first_LG!=$intxt[0]);
	$order{$intxt[1]}{"interval"}=$i*2000000;
	$first_LG=$intxt[0];
	$col{$intxt[1]}{"max"}=0;
	$col{$intxt[1]}{"min"}=1000000;
}
close (INTXT);

my %excel=();
foreach my $inexcel(<INEXCEL>){
	chomp $inexcel;
	next if ($inexcel=~/^LG.*/);
	my @inexcel=split(/\t/,$inexcel);
	if ($order{$inexcel[2]}{"orientation"} eq "+"){
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"}=($order{$inexcel[2]}{"startsite"}+$inexcel[3]-1+$order{$inexcel[2]}{"interval"})/1000000;
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"lgcm"}=$inexcel[4];
	}elsif ($order{$inexcel[2]}{"orientation"} eq "-"){
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"}=(($order{$inexcel[2]}{"length"}-$inexcel[3])+$order{$inexcel[2]}{"startsite"}+$order{$inexcel[2]}{"interval"})/1000000;
		$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"lgcm"}=$inexcel[4];
	}
	$col{$inexcel[2]}{"max"}=$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"} if ($col{$inexcel[2]}{"max"}<$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"});
	$col{$inexcel[2]}{"min"}=$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"} if ($col{$inexcel[2]}{"min"}>$excel{$order{$inexcel[2]}{"LG"}}{$inexcel[1]}{"scaffold"});
}
close (INEXCEL);

my $fh="A";
foreach my $key1(sort {$a <=> $b} keys %excel){
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
	print OUTCOLFRAME "Physical$order{$key}{'LG'}\t$col{$key}{'min'}\t$col{$key}{'max'}\torange\n"
}
close (OUTCOLFRAME);


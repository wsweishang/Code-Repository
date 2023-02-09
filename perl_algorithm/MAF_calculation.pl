#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

#给一个基因型分布表，计算出每个等位基因的频率。
#要得到频率，只需将得到的频数除以总数。

#my ($a,$b) = @ARGV;
$a='gene.txt';
#$b = 'hweout_rs';
my %hash;
open A,"$a" or die;
my $head = <A>;
chomp $head;
my @line1=split/\t/,$head;

while(<A>){
    chomp;
    my @t=split/\t/,$_;
    for my $i (1 .. $#t){
        my @geno = split//,$t[$i];
        my @st = sort{$a cmp $b } @geno;
        my $nsc=$st[0].$st[1];
        $hash{$line1[$i]}{$st[0]} +=1;
        $hash{$line1[$i]}{$st[1]} +=1;
    }
}
#print Dumper(\%hash);
for my $rs(sort keys %hash){
    for my $key(sort keys %{$hash{$rs}}){
        print "$rs\t$key\t$hash{$rs}{$key}\n";
    }
}







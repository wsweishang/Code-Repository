#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#====================================
#fasta序列转换成excel文件
#====================================

open (IN,"<D:/005bs vs 0bs .fasta") or die "$!";
open (OUT,">D:/out.fasta") or die "$!";

my @ID=<IN>;
foreach my $ID (@ID){
	$ID=~s/^([A-Z]+)\n/$1/g;  #去除序列换行符
	$ID=~s/(>.*)\n/$1\t/g;   #标头与序列之间加上制表符
	if ($ID=~/\|.*\|/){
		$ID=~s/(\|.*\|)/$1\t/g;   #在gi号之后加上制表符
	}
	if ($ID=~/\d.\d\s/){
		$ID=~s/(\d.\d)\s/$1\t/g;   #在另一种gi号之后加上制表符
	}
}
print OUT @ID;
close (IN);
close (OUT);

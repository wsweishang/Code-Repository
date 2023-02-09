#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#====================================
#fasta����ת����excel�ļ�
#====================================

open (IN,"<D:/005bs vs 0bs .fasta") or die "$!";
open (OUT,">D:/out.fasta") or die "$!";

my @ID=<IN>;
foreach my $ID (@ID){
	$ID=~s/^([A-Z]+)\n/$1/g;  #ȥ�����л��з�
	$ID=~s/(>.*)\n/$1\t/g;   #��ͷ������֮������Ʊ��
	if ($ID=~/\|.*\|/){
		$ID=~s/(\|.*\|)/$1\t/g;   #��gi��֮������Ʊ��
	}
	if ($ID=~/\d.\d\s/){
		$ID=~s/(\d.\d)\s/$1\t/g;   #����һ��gi��֮������Ʊ��
	}
}
print OUT @ID;
close (IN);
close (OUT);

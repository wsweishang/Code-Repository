#!/usr/bin/perl

use strict;
use warnings;

#=====================================================================
#ͳ��fasta�ļ���scaffold���Ⱥ�ATCGN����Ŀ
#=====================================================================

open (SMG,"<SMGenome.fasta");
open (OUT,">count_result.txt");

my %hash=();
my $chr=();
while(<SMG>){
	chomp;
	if(/>(.+)/){ #".+"��ʾƥ�䵽�����ַ�һ�μ�����
		$chr=$1;
	}else {
		$hash{$chr}.=$_;
	}
}

foreach my $key (sort keys %hash){
	my $len=length $hash{$key};   #count length of seq
	my $countA=$hash{$key}=~s/A/A/g;   #count Number of letter A
	my $countT=$hash{$key}=~s/T/T/g;
	my $countC=$hash{$key}=~s/C/C/g;
	my $countG=$hash{$key}=~s/G/G/g;
	my $countN=$hash{$key}=~s/N/N/g;
	print OUT "$key\t$len\n";
#print "The number of five kinds of basepair are :\n";
#print "A:\t$countA\t C:\t$countC\t G:\t$countG\t T:\t$countT\t N:\t$countN \n\n";
}
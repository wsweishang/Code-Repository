#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#======================================================
#判断两个fasta文件每行长度
#======================================================

open (IN,"<G:/grasscarp_8populations/result/Scaffold/C_idella_female_scaffolds_fasta_out.txt") or die "$!";
open (IN1,"<G:/grasscarp_8populations/result/Scaffold/C_idella_female_scaffolds_fasta_out_1.txt") or die "$!";

my @in=<IN>;
my @in1=<IN1>;

foreach my $in(@in){
	chomp $in;
	my $length=length $in;
	say $in if ($in=~/^>.*/);
	say $length;	
}

foreach my $in1(@in1){
	chomp $in1;
	my $length1=length $in1;
	say $in1 if ($in1=~/^>.*/);
	say $length1;
}






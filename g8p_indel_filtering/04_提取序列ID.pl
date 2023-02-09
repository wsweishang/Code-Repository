#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#====================================
#提取序列第一行：GeneID
#====================================

open (IN,"<G:/result/AX_out.txt");
open (OUT,">G:/AX_single_line.txt");


while (my $infile=<IN>){
	my @infile=split (/\t/,$infile);
	say OUT $infile[0];
}
close (IN);
close (OUT);
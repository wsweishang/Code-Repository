#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#========================
#perl文件读取与输出
#========================

open(IN,"<D:/1.txt") or die "can't INFILE D:/1.txt";
open(OUT,">D:/2.txt") or die "can't OUTFILE D:/2.txt";
#open(OUT2,">>D:/2.txt") or die "can't OUTFILE D:/2.txt";

while(my $word=<IN>){
	my $word2=lc $word;
	my $word3=ucfirst $word2;
	print OUT $word3;
}

close(IN);
close(OUT);
#close(OUT2);


my @list = (100, 200, 300);
my @results = map($_+1, @list);
#my @results2 = map(&mysub($_), @list); 
say @results;
#say @results2;
say @list;
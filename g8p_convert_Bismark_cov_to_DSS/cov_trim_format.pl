#!/usr/bin/perl

use strict;
use warnings;

my @files_path=glob "/home/yinglu/grasscarp_reseq_8populations/Methylation/Cleandata/cov/*.deduplicated.bismark.cov";
foreach my $file_path(@files_path){
	open (IN,"<$file_path") or die "$!";
	(my $file_name=$file_path)=~s/(.*\/[0-9A-Z_]+)_bismark.*/$1/;
	open (OUT,">${file_name}.cov") or die "$!";
	foreach my $file_data(<IN>){
		chomp $file_data;
		my @file_data=split (/\t/,$file_data);
		my $total_reads_num=$file_data[4]+$file_data[5];
		print OUT "$file_data[0]\t$file_data[1]\t$total_reads_num\t$file_data[4]\n";
	}
}

close (IN);
close (OUT);






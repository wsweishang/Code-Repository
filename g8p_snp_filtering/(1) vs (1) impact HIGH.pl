#!/usr/bin/perl

use strict;
use warnings;

mkdir "G:/result";

my @files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";
my %compared_data=();
foreach my $file_a(@files){
	open (INCOMPARED,"<$file_a");
	undef %compared_data;
	foreach my $compared_data(<INCOMPARED>){
		chomp $compared_data;
		next if ($compared_data=~/^#.*/);
		my @compared_content=split(/\t/,$compared_data);
		next if ($compared_content[1]=~/.*circ$/);
		next if ($compared_content[4]==0);
		$compared_data{$compared_content[0]}=1;
	}
	foreach my $file_b(@files){
		next if ($file_a eq $file_b);
		open (INCOMPARE,"<$file_b");		
		my @file_a=split (/\//,$file_a);
		my @file_b=split(/\//,$file_b);
		my $a=pop @file_a;
		my $b=pop @file_b;
		$a=substr($a,0,2);
		$b=substr($b,0,2);
		open (OUT,">G:/result/$b vs $a.txt");
		foreach my $compare_data(<INCOMPARE>){
			chomp $compare_data;
			next if ($compare_data=~/^#.*/);
			my @compare_content=split(/\t/,$compare_data);
			next if ($compare_content[1]=~/.*circ$/);
			next if ($compare_content[4]==0);
			unless (exists $compared_data{$compare_content[0]}){
				if ($compare_content[4]>0){
					print OUT "$compare_data\n";
				}
			}
		}
	}
}
close (INCOMPARED);
close (OUT);






#!/usr/bin/perl

use strict;
use warnings;

my $B="ZQ";
my @all_files_path=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";
my @B=grep (/$B/,@all_files_path);
@all_files_path=grep (!/$B/,@all_files_path);

my %file_B_data=();
open (INFILEBDATA,"<$B[0]") or die "$!";
foreach my $file_B_data(<INFILEBDATA>){
	chomp $file_B_data;
	next if ($file_B_data=~/^#.*/);
	my @file_B_data=split (/\t/,$file_B_data);
	$file_B_data{$file_B_data[0]}="1" unless ($file_B_data[1]=~/.*_circ$/);
}

mkdir "G:/grasscarp_8populations/7_vs_ZQ_snpEFF_snp_result";

foreach my $file_A_path(@all_files_path){
	open (INFILEA,"<$file_A_path");
	$file_A_path=~/.*\/([A-Z]{2})_.*/;
	my $current_ID=$1;
	print "$current_ID\n";
	open (OUT,">G:/grasscarp_8populations/7_vs_ZQ_snpEFF_snp_result/${current_ID}_vs_${B}.txt");
	foreach my $file_A_data(<INFILEA>){
		chomp $file_A_data;
		next if ($file_A_data=~/^#.*/);
		my @file_A_data=split (/\t/,$file_A_data);
		next if ($file_A_data[1]=~/.*_circ$/);
		unless (exists $file_B_data{$file_A_data[0]}){
			if ($file_A_data[4]>0){
					print OUT "$file_A_data[0]\n";
			}
		}	
	}
}

close (INFILEA);
close (OUT);

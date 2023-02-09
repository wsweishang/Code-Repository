#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use File::Basename;
use Data::Dumper;

my $data_files=();
my $data_file_name=();
my %reference_data=();

my @data_files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/indel/*.txt";
foreach $data_files(@data_files){
	$data_file_name=basename ($data_files,".txt");
	open (IN,"<$data_files");
	foreach my $reference_data(<IN>){
		chomp $reference_data;
		next if ($reference_data=~/^#.*/);
		my @reference_data=split (/\t/,$reference_data);
		$reference_data{$data_file_name}{$reference_data[1]}=$reference_data;
	}
}
close (IN);

sub SUM{
	my @all=@_;
	$all[15] += $all[13];
	$all[16] += $all[15];
	$all[18] += $all[16];
	$all[19] += $all[18];
	$all[20] += $all[19];
	return $all[20];
}

my $except_files=();
my $except_file_name=();
my $reference_files=();
my $reference_file_name=();
my $reference_data=();
my @reference_data=();
my $result=();
my %check=();

foreach $except_files(@data_files){
	$except_file_name=basename ($except_files,".txt");
	open (IN2,"<$except_files");
	foreach $reference_data(<IN2>){
		chomp $reference_data;
		next if ($reference_data=~/^#.*/);
		my @reference_data=split (/\t/,$reference_data);
		foreach $reference_files(@data_files){
			$reference_file_name=basename ($reference_files,".txt");
			next if ($except_file_name eq $reference_file_name);
			if (exists $reference_data{$reference_file_name}{$reference_data[1]}){
				$check{$except_file_name}{$reference_data[1]}="exist already";
			}
		}
	}
}
close (IN2);

foreach $except_files(@data_files){
	$except_file_name=basename ($except_files,".txt");
	open (IN3,"<$except_files");
	open (OUT,">G:/grasscarp_8populations/result/SNP_INDEL/INDEL/1vs7/grasscarp_8populations_$except_file_name"."_INDEL_1vs7_uniqueGeneID_comparison_output".".txt");
	
	foreach $reference_data(<IN3>){
		chomp $reference_data;
		next if ($reference_data=~/^#.*/);
		my @reference_data=split (/\t/,$reference_data);
		
		unless (exists $check{$except_file_name}{$reference_data[1]}){
			$result=&SUM(@reference_data);
			unless ($result==0){
				say OUT $reference_data;
			}
		}
	}
}
close (IN3);
close (OUT);

open (OUT,">G:/grasscarp_8populations/result/SNP_INDEL/INDEL/grasscarp_8populations_INDEL_common_exist_GeneID.txt");
say OUT Dumper (\%check);
close (OUT);




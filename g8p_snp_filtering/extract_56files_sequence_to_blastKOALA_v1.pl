#!/usr/bin/perl

use strict;
use warnings;

open (INGCPROTEINDATA,"<$ARGV[0]");
my $protein_id=();
my %protein_data=();
foreach my $gc_protein_data(<INGCPROTEINDATA>){
	chomp $gc_protein_data;
	if ($gc_protein_data=~/^>([A-Z0-9_]+).*/){
		$protein_id=$1;
	}else {
		$protein_data{$protein_id}=$gc_protein_data;
		undef $protein_id;
	}
}

my %file_data=();
my @files_path=glob "$ARGV[1]/*.txt";
foreach my $file_path(@files_path){
	open (INFILESPATH,"<$file_path");
	foreach my $file_data(<INFILESPATH>){
		chomp $file_data;
		my @file_data=split (/\t/,$file_data);
		unless (exists $file_data{$file_data[0]}){
			$file_data{$file_data[0]}=1;
		}
	}
}
open (OUT1,">result.txt") or die "$!";
open (OUT2,">error.txt") or die "$!";
foreach my $key(keys %file_data){
	if (exists $protein_data{$key}){
		print OUT1 "$key\n";
		print OUT1 "$protein_data{$key}\n";
	}else {
		print OUT2 "$key\n";
	}
}













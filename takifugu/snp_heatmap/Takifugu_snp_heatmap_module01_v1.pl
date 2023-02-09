#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
#open (POPLIST, "<$ARGV[0]") or die "$!";
open (VCF, "<D:/research work/Takifugu/ÔÓÏî/heatmap/test.vcf") or die "$!";
open (OUT, "<D:/research work/Takifugu/ÔÓÏî/heatmap/test.txt") or die "$!";
#####################################################################################################
my (@sample_name_list, @group_name_list, %sample_group) = ();
while (<DATA>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	$sample_group{$data[0]} = $data[1];
	push (@sample_name_list, $data[0]);
	push (@group_name_list, $data[1]) unless (exists $sample_group{$data[1]});
	$sample_group{$data[1]} = $data[0];
	print OUT join ("\t", @group_name_list), "\n";
}
#####################################################################################################
my (@header, %snp_info) = ();
while (<VCF>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		my @header = split (/\t/, $data);
		splice (@header, 0, 8);
		@header = map {$_, $_} @header;
		print OUT "#CHROM\tPOS\tREF\tALT\t", join ("\t", @sample_name_list), "\n";
		next;
	}
	my @data = split (/\t/, $data);
	next if ((length $data[4]) > 3);
	
	
	
	my @allele = split (/[\|\/\t]+/, $data);
	my @info = splice (@allele, 0, 4);
	print OUT "";
	my (%code, %temp1, %temp2) = ();
	for (my $i = 0; $i <= $#allele; $i++) {
		my ($allele, $group_name) = ($allele[$i], $sample_group{$header[$i]});
		$temp1{$allele}{$group_name}++;
		$temp1{$allele}{"all_count"}++;
		$temp1{$group_name}{"count"}++;
	}
	my @all_count = map {$_ -> {"all_count"}} @temp1{"0", "1", "2"};
	my @sorted_all_count = sort {$all_count[$a] <=> $all_count[$b]} (0..$#all_count);
	my $code3 = shift @sorted_all_count;
	$code{"."} = 4;
	$code{$code3} = 3;
	foreach my $allele (@sorted_all_count) {
		foreach my $group_name (@group_name_list) {
			my $code3_count = ($temp1{"."}{$group_name}) ? $temp1{"."}{$group_name} : 0;
			my $code4_count = ($temp1{"2"}{$group_name}) ? $temp1{"2"}{$group_name} : 0;
			my $allele_count = ($temp1{$allele}{$group_name}) ? $temp1{$allele}{$group_name} : 0;
			$temp2{$allele}{$group_name} = $allele_count / ($temp1{$group_name}{"count"} - $code3_count - $code4_count);
		}
	}
	if ($temp2{$sorted_all_count[0]}{$group_name_list[0]} > $temp2{$sorted_all_count[0]}{$group_name_list[1]}) {
		$code{$sorted_all_count[0]} = 1;
		$code{$sorted_all_count[1]} = 2;
	} elsif ($temp2{$sorted_all_count[0]}{$group_name_list[0]} < $temp2{$sorted_all_count[0]}{$group_name_list[1]}) {
		$code{$sorted_all_count[0]} = 2;
		$code{$sorted_all_count[1]} = 1;
	} else {
		$code{$sorted_all_count[0]} = 1;
		$code{$sorted_all_count[1]} = 2;
	}
	
	
	
	
	
	
	foreach my $allele (@allele) {
		
	}
	
	
	
	
	
#	print @group_name_list;
#	print Dumper (\%temp2);
	print Dumper (\%code);
#	print "@sorted_all_count\n";
	last;
}
close (VCF);
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
__DATA__
T-A-01	TA
T-A-02	TA
T-A-03	TA
T-A-04	TA
T-A-05	TA
T-A-06	TA
T-A-07	TA
T-A-08	TA
T-A-09	TA
T-A-10	TA
T-A-11	TA
T-A-12	TA
T-A-13	TA
T-A-14	TA
T-A-15	TA
T-A-16	TA
T-A-17	TA
T-A-18	TA
T-A-19	TA
T-A-20	TA
T-A-21	TA
T-A-22	TA
T-U-01	TU
T-U-02	TU
T-U-03	TU
T-U-04	TU
T-U-05	TU
T-U-06	TU
T-U-07	TU
T-U-08	TU
T-U-09	TU
T-U-10	TU
T-U-11	TU
T-U-12	TU
T-U-13	TU
T-U-14	TU
T-U-15	TU
T-U-16	TU
T-U-17	TU
T-U-18	TU
T-U-19	TU
T-U-20	TU
T-U-21	TU
T-U-22	TU
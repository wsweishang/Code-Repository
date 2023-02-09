#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
#open (POPLIST, "<$ARGV[0]") or die "$!";
open (VCF, "<D:/research work/Takifugu/‘”œÓ/heatmap/test.vcf") or die "$!";
open (OUT, ">D:/research work/Takifugu/‘”œÓ/heatmap/test.txt") or die "$!";
#####################################################################################################
my (@sample_name_list, @group_name_list, %sample_group) = ();
while (<DATA>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	$sample_group{$data[0]} = $data[1];
	push (@sample_name_list, "$data[0]_1");
	push (@sample_name_list, "$data[0]_2");
	push (@group_name_list, $data[1]) unless (exists $sample_group{$data[1]});
	$sample_group{$data[1]} = $data[0];
	
}
#####################################################################################################
my (@header) = ();
while (<VCF>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		if ($data =~ /^#CHROM.*/) {
			@header = split (/\t/, $data);
			print OUT "#", join ("\t", @group_name_list), "\n";
			print OUT "#CHROM\tPOS\tREF\tALT\t", join ("\t", @sample_name_list), "\n";
		}
		next;
	}
	next unless ($. == 420);
	my @data = split (/\t/, $data);
	next if ((length $data[4]) > 3);
	my (@all_count, @sorted_all_count, %code, %temp1, %temp2, %snp_info) = ();
	for (my $i = 9; $i <= $#data; $i++) {
		my $allele_1 = substr ($data[$i], 0, 1);
		my $allele_2 = substr ($data[$i], 2, 1);
		$temp1{$allele_1}{"all_count"}++;
		$temp1{$allele_2}{"all_count"}++;
		$temp1{$allele_1}{$sample_group{$header[$i]}}++;
		$temp1{$allele_2}{$sample_group{$header[$i]}}++;
		$temp1{$sample_group{$header[$i]}}{"count"} += 2;
		$snp_info{"$header[$i]_1"} = $allele_1;
		$snp_info{"$header[$i]_2"} = $allele_2;
	}
#	@all_count = map {$_ -> {"all_count"}} @temp1{"0", "1"};
	push (@all_count, $temp1{"1"}{"all_count"});
	if ($temp1{"0"}{"all_count"}) {
		unshift (@all_count, $temp1{"0"}{"all_count"});
	}
	@sorted_all_count = sort {$all_count[$a] <=> $all_count[$b]} (0..$#all_count);
	if ($temp1{"2"}{"all_count"}) {
		push (@all_count, $temp1{"2"}{"all_count"});
		@sorted_all_count = sort {$all_count[$a] <=> $all_count[$b]} (0..$#all_count);
		my $code3 = shift @sorted_all_count;
		$code{$code3} = 4;
	}
	$code{"."} = 3;
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
		$code{$sorted_all_count[1]} = 2 if ($code{$sorted_all_count[1]});
	} elsif ($temp2{$sorted_all_count[0]}{$group_name_list[0]} < $temp2{$sorted_all_count[0]}{$group_name_list[1]}) {
		$code{$sorted_all_count[0]} = 2;
		$code{$sorted_all_count[1]} = 1 if ($code{$sorted_all_count[1]});
	} else {
		$code{$sorted_all_count[0]} = 1;
		$code{$sorted_all_count[1]} = 2 if ($code{$sorted_all_count[1]});
	}
	print OUT "$data[0]\t$data[1]\t$data[3]\t$data[4]";
	foreach my $sample_name (@sample_name_list) {
		print OUT "\t$code{$snp_info{$sample_name}}";
	}
	print OUT "\n";
	
	
	
	
#	map {print "$_\n"} @group_name_list;
#	map {print "$_\n"} @sample_name_list;
#	map {print "$_\n"} @sorted_all_count;
	print Dumper (\%temp1);
#	print Dumper (\%temp2);
#	print Dumper (\%code);
#	print Dumper (\%snp_info);
#	last;
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
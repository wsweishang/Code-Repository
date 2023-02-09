#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (POPLIST, "<D:/research work/Takifugu/‘”œÓ/heatmap/test_poplist.txt") or die "$!";
open (VCF, "<D:/research work/Takifugu/‘”œÓ/heatmap/test.vcf") or die "$!";
open (OUT, ">D:/research work/Takifugu/‘”œÓ/heatmap/test.txt") or die "$!";
#####################################################################################################
my (@group_name, %sample_group) = ();
while (<POPLIST>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	$sample_group{$data[0]} = $data[1];
	push (@group_name, $data[1]) unless ($sample_group{$data[1]});
	$sample_group{$data[1]} = $data[0];
}
close (POPLIST);
#####################################################################################################
my (@index, @header, @sample_name) = ();
while (<VCF>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		if ($data =~ /^#CHROM.*/) {
			@header = split (/\t/, $data);
			for (my $i = 9; $i <= $#header; $i++) {
				if ($sample_group{$header[$i]}) {
					push (@index, $i);
					push (@sample_name, "$header[$i]_1");
					push (@sample_name, "$header[$i]_2");
				}
			}
			print OUT "#CHROM\tPOS\tREF\tALT\t", join ("\t", @sample_name), "\n";
		}
		next;
	}
	my @data = split (/\t/, $data);
	next if ((length $data[4]) > 1);
	my ($code, @snp_info, %code, %temp) = ();
	foreach my $index (@index) {
		my $allele_1 = substr ($data[$index], 0, 1);
		my $allele_2 = substr ($data[$index], 2, 1);
		$temp{$sample_group{$header[$index]}}{$allele_1}++;
		$temp{$sample_group{$header[$index]}}{$allele_2}++;
		push (@snp_info, $allele_1);
		push (@snp_info, $allele_2);
	}
	foreach my $group_name (@group_name) {
		delete $temp{$group_name}{"."} if ($temp{$group_name}{"."});
		$code{"."} = 0;
	}
	my @allele = keys %{$temp{$group_name[0]}};
	next if (@allele == 1);
	my @sorted_allele = sort {$temp{$group_name[0]}{$b} <=> $temp{$group_name[0]}{$a}} @allele;
	foreach my $first_group_allele (@sorted_allele) {
		$code++;
		$code{$first_group_allele} = $code;
	}
	foreach my $second_group_allele (keys %{$temp{$group_name[1]}}) {
		unless ($code{$second_group_allele}) {
			$code++;
			$code{$second_group_allele} = $code;
		}
	}
	print OUT "$data[0]\t$data[1]\t$data[3]\t$data[4]";
	foreach my $snp_info (@snp_info) {
		print OUT "\t$code{$snp_info}";
	}
	print OUT "\n";
}
close (VCF);
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
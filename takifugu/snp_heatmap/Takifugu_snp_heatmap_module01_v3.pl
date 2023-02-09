#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (VCF, "<D:/research work/Takifugu/‘”œÓ/heatmap/test.vcf") or die "$!";
open (OUT, ">D:/research work/Takifugu/‘”œÓ/heatmap/test.txt") or die "$!";
#####################################################################################################
my (@header, @sample_name_list) = ();
while (<VCF>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		if ($data =~ /^#CHROM.*/) {
			@header = split (/\t/, $data);
			my @temp = @header;
			splice (@temp, 0, 9);
			foreach my $sample_name (@temp) {
				push (@sample_name_list, "${sample_name}_1");
				push (@sample_name_list, "${sample_name}_2");
			}
			print OUT "#CHROM\tPOS\tREF\tALT\t", join ("\t", @sample_name_list), "\n";
		}
		next;
	}
	my @data = split (/\t/, $data);
	next if ((length $data[4]) > 3);
	my (%code, %temp, %snp_info) = ();
	for (my $i = 9; $i <= $#data; $i++) {
		my $allele_1 = substr ($data[$i], 0, 1);
		my $allele_2 = substr ($data[$i], 2, 1);
		$temp{$allele_1}++;
		$temp{$allele_2}++;
		$snp_info{"$header[$i]_1"} = $allele_1;
		$snp_info{"$header[$i]_2"} = $allele_2;
	}
	if (exists $temp{"."}) {
		delete $temp{"."};
		$code{"."} = 0;
	}
	my @all_count = keys %temp;
	my @sorted_all_count = sort {$temp{$b} <=> $temp{$a}} @all_count;
	for (my $i = 0; $i <= $#sorted_all_count; $i++) {
		$code{$sorted_all_count[$i]} = $i + 1;
	}
	print OUT "$data[0]\t$data[1]\t$data[3]\t$data[4]";
	foreach my $sample_name (@sample_name_list) {
		print OUT "\t$code{$snp_info{$sample_name}}";
	}
	print OUT "\n";
}
close (VCF);
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
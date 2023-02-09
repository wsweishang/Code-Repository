#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (TXT, "<D:/research work/Takifugu/‘”œÓ/heatmap/test.txt") or die "$!";
open (REGIONLIST, "<D:/research work/Takifugu/‘”œÓ/heatmap/test_region.txt") or die "$!";
open (OUT, ">D:/research work/Takifugu/‘”œÓ/heatmap/input_2.txt") or die "$!";
#####################################################################################################
my (@sample_name, %snp_info) = ();
while (<TXT>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		if ($data =~ /^#CHROM.*/) {
			my @data = split (/\t/, $data);
			for (my $i = 4; $i <= $#data; $i++) {
				$data[$i] =~ s/-/_/g;
				push (@sample_name, $data[$i]);
			}
			print OUT "Sample\tPosition\tGenotype\n";
		}
		next;
	}
	my @data = split (/\t/, $data);
	for (my $i = 4; $i <= $#sample_name; $i++) {
		$snp_info{$data[0]}{$data[1]}{$sample_name[$i]} = $data[$i];
	}
}
close (TXT);
#####################################################################################################
while (<REGIONLIST>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	my $site = ();
	if ($data[3]) {
		open (OUT, ">$data[3]") or die "$!";
	} else {
		my $output_filename = "$data[0]_$data[1]_$data[2].txt";
		open (OUT, ">$output_filename") or die "$!";
	}
	foreach my $pos (sort {$a <=> $b} keys %{$snp_info{$data[0]}}) {
		if ($data[1] <= $pos && $pos <= $data[2]) {
			$site++;
			foreach my $sample_name (@sample_name) {
				print OUT "$sample_name\t$site\t$snp_info{$data[0]}{$pos}{$sample_name}\n";
			}
		}
	}
	close (OUT);
}
close (REGIONLIST);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
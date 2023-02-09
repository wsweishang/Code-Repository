#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (IN, "<D:/mrcong/record_cloud_page_url_list_v2.txt") or die "$!";
open (OUT, ">D:/mrcong/record_cloud_page_url_list_v1.txt") or die "$!";

my %hash = ();
while (<IN>) {
	chomp (my $data = $_);
	my @data = split (/\t/, $data);
	
	my $code = ();
	if ($data[3] =~ /mediafire/) {
		$code = 1;
	} else {
		$code = 0;
	}
	$hash{$data[0]}{"sum"} += $code;
	$hash{$data[0]}{$code}{$data[3]} = $data;
}
close (IN);


foreach my $number (sort {$a <=> $b} keys %hash) {
	
	my $code = ();
	if ($hash{$number}{"sum"} >= 1) {
		$code = 1;
	} else {
		$code = 0;
	}
	
	foreach my $url (keys %{$hash{$number}{$code}}) {
		print OUT "$hash{$number}{$code}{$url}\n";
	}
}
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
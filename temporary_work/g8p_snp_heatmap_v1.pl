#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (IN, "<D:/input.txt") or die "$!";
open (OUT, ">D:/output.txt") or die "$!";
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
my (@header) = ();
while (<IN>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		my @data = split (/\t/, $data);
		splice (@data, 0, 5);
#		push (@header, );
		print OUT "#CHROM\tPOS\tREF\tALT\t", join ("\t", @sample_name_list), "\n";
		next;
	}
	my @data = split (/\t/, $data);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
close (IN);
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
__DATA__


























#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (my $file_handle, "<D:/input.txt") or die "$!";

my @pos = ("0");

while (<$file_handle>) {
	chomp(my $data = $_);
	push(@pos, tell $file_handle) ;
}
map {print "$_\n"} @pos;
foreach my $pos (@pos) {
	seek($file_handle, $pos, 0);
	while (<$file_handle>) {
		chomp(my $data = $_);
		print "$data ";
		
		last if (tell $file_handle);
	}
	
#	seek($file_handle, $pos, 1);
	
	
}




















close ($file_handle);

























































####################################################################################################
printf "[total run time: %f s]\n", gettimeofday - $start_time;
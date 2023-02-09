#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
my $window_start = 1;
my $window_length = 100;
my $window_steplen = 20;
#####################################################################################################
sub OVERLAP_WINDOW {
	my $site = $_[0];
	my $left_window_code = ($site > $window_length) ? int (($site - $window_length - $window_start) / $window_steplen) + 1: 0;
	my $right_window_code = int (($site - $window_start) / $window_steplen);
	return ($left_window_code, $right_window_code);
}

sub WINDOW_RANGE {
	my ($window_code, $max_length) = @_[0, 1];
	my $left = $window_start + $window_code * $window_steplen;
	my $right = (($left + $window_length - 1) > $max_length) ? $max_length : $left + $window_length - 1;
	return ($left, $right);
}
#####################################################################################################
my %temp1 = ();
my $max_length = 0;
while (<DATA>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my ($site, $number) = (split (/\t/, $data))[0..1];
	my ($left_window_code, $right_window_code) = &OVERLAP_WINDOW ($site);
	map {$temp1{$_} += $number} $left_window_code..$right_window_code;
	$max_length = $site if ($max_length < $site);
}

my $max_code = int ($max_length / $window_steplen - 1);
foreach my $window_code (0..$max_code) {
	my ($left, $right) = &WINDOW_RANGE ($window_code, $max_length);
	my $result = ($temp1{$window_code}) ? $temp1{$window_code} : 0;
	print "$window_code\t$left\t$right\t$result\n";
}
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
__DATA__
#Site	Number
80	0
81	1
82	2
83	3
84	4
85	5
86	6
87	7
88	8
89	9
130	10
131	11
132	12
133	13
134	14
135	15
136	16
137	17
138	18
139	19
140	20
141	21
142	22
143	23
144	24
500	25
#!/usr/bin/perl

use strict;
use warnings;
#==================================================================
my @align=();
my @max_len = ();
my %final = ();
my $max_len = 0;
my $start = 1;
while (<DATA>) {
	chomp (my $data = $_);
	my @data = split (/\t/, $data);
	 if ($align[$data[0]]) {
	 	$align[$data[0]] = $data[1] if ($align[$data[0]] <= $data[1]);
	 } else {
	 	$align[$data[0]] = $data[1];
	 }
}
while ($start) {
	my $aa = $start;
	my $bb = $align[$start];
	my ($aaa, $bbb, $start1) = &MAIN ($aa, $bb, $start);	
	$start = $start1;
}
foreach my $key (sort {$a <=> $b} keys %final) {
	print "$key => $final{$key}\n";
}
#==================================================================
sub MAIN {
	my ($start_site, $end_site, $passed_pos) = @_;
	my $nextvaildpos = &NEXTVALIDPOS ($passed_pos);
	if (!$nextvaildpos){
		$final{$start_site} = $end_site;
		return ($start_site, $end_site, undef);
	}
	my $overlap_result = &OVERLAP ($start_site, $end_site, $nextvaildpos, $align[$nextvaildpos]);
	if ($overlap_result){
		$max_len = $align[$passed_pos] - $passed_pos if ($start_site == $passed_pos);
		my $a_length = $align[$passed_pos] - $passed_pos;
		my $b_length = $align[$nextvaildpos] - $nextvaildpos;
		if ($b_length >= $max_len) {
			$max_len[0] = $nextvaildpos;
			$max_len[1] = $align[$nextvaildpos];
			$max_len = $b_length;
		} else {
			$max_len[0] = $start_site;
			$max_len[1] = $align[$start_site];
		}
		my @sort = ($start_site, $end_site, $nextvaildpos, $align[$nextvaildpos]);
		@sort = sort {$a <=> $b} @sort;
		&MAIN ($start_site, $sort[-1], $nextvaildpos);
	} elsif ($start_site == $passed_pos) {
		$final{$start_site} = $end_site;
		return ($start_site, $end_site, $nextvaildpos);
	} else {
		$final{$max_len[0]} = $max_len[1];
		return ($start_site, $end_site, $nextvaildpos);
	}
}

sub OVERLAP {
	my ($a_start, $a_end, $b_start, $b_end) = @_;
	my $left = $a_end - $b_start;
	my $right = $a_start - $b_end;
	if ($left > 0 and $right < 0){
		return 1;   #overlaped
	} else {
		return undef;   #unoverlaped
	}
}

sub NEXTVALIDPOS {
	my $position = $_[0] + 1;
	my $max = $#align;
	if ($align[$position]) {
		return $position;   #return next valid position
	} elsif ($position < $max) {
		&NEXTVALIDPOS ($position);
	} else {
		return undef;   #doesnt exist next valid position
	}
}

__DATA__
1	3
4	6
8	10
9	10
7	15
15	17
4	5
20	21
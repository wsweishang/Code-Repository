#!/usr/bin/perl

use strict;
use warnings;
#use Benchmark;
use Time::HiRes qw(gettimeofday);

my $start_time = gettimeofday;

open (TXT, "<$ARGV[0]") or die "$!";
open (OUT, ">$ARGV[1]") or die "$!";

my %bam = ();
while (<TXT>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my ($path, $code) = (split (/\t/, $txt))[0..1];
	open (BAM, "<$path");
	while (<BAM>) {
		chomp (my $bam = $_);
		next if ($bam =~ /^@.*/);
		my ($qname, $flag, $chr) = (split (/\t/, $bam))[0..2];
		$qname =~ s/[:\+]/_/g;
		$bam{$qname}{$code} = 1;
	}
	printf "processing: $code... [run time: %f s]\n", gettimeofday - $start_time;
}
close (TXT);
close (BAM);

my ($num, @cal) = ();
foreach my $qname (keys %bam) {
	my $score = ();
	$score += 1 if ($bam{$qname}{"Blue"});
	$score += 2 if ($bam{$qname}{"Nile"});
	$score += 4 if ($bam{$qname}{"Merged"});
	$cal[$score]++;
	$num++;
}
printf "processing: calculation... [run time: %f s]\n", gettimeofday - $start_time;

print OUT "#score\tcount\tall_num\n";
for (my $i = 0; $i <= 7; $i++) {
	$cal[$i] = ($cal[$i])? $cal[$i]: 0;
	print OUT "$i\t$cal[$i]\t$num\n";
}
close (OUT);
printf "finished... [total run time: %f s]\n", gettimeofday - $start_time;

#my @result = ();
#my @flag = qw/2048 1024 512 256 128 64 32 16 8 4 2 1/;
#
#undef @result;
#my @gh = &FLAG (6, 0);
#print "@gh\n";
#
#sub FLAG {
#	my ($number, $i) = @_[0..1];
#	if ($i <= $#flag) {
#		if ($number >= $flag[$i]) {
#			push (@result, $flag[$i]);
#			$number -= $flag[$i];
#			$i++;
#			&FLAG ($number, $i);
#		} else {
#			$i++;
#			&FLAG ($number, $i);
#		}
#	} else {
#		return (@result);
#	}
#}

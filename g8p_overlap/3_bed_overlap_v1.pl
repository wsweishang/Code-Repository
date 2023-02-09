#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (INA, "<$ARGV[0]") or die "$!";
open (INB, "<$ARGV[1]") or die "$!";
open (INC, "<$ARGV[2]") or die "$!";
open (OUT, ">$ARGV[3]") or die "$!";
####################################################################################################
my (%bed_a, %range) = ();
while (<INA>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my ($chr, $start, $end) = (split (/\t/, $data))[0..2];
	map {$bed_a{$chr}{$_} = "$chr\t$start\t$end"} $start..$end;
	push (@{$range{$chr}{"start"}}, $start);
	push (@{$range{$chr}{"end"}}, $end);
}
close (INA);

my (%bed_b) = ();
while (<INB>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my ($chr, $start, $end) = (split (/\t/, $data))[0..2];
	map {$bed_b{$chr}{$_} = "$chr\t$start\t$end"} $start..$end;
	push (@{$range{$chr}{"start"}}, $start);
	push (@{$range{$chr}{"end"}}, $end);
}
close (INB);

my (%bed_c) = ();
while (<INC>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my ($chr, $start, $end) = (split (/\t/, $data))[0..2];
	map {$bed_c{$chr}{$_} = "$chr\t$start\t$end"} $start..$end;
	push (@{$range{$chr}{"start"}}, $start);
	push (@{$range{$chr}{"end"}}, $end);
}
close (INC);

my (%overlap) = ();
foreach my $chr (sort {$a cmp $b} keys %range) {
	my $start = (sort @{$range{$chr}{"start"}})[0];
	my $end = (sort @{$range{$chr}{"end"}})[-1];
	my $status_1 = 1;
	for (my $i = $start; $i <= $end; $i++) {
		my $status_2 = 1;
		if ($bed_a{$chr}{$i}) {
			if ($bed_b{$chr}{$i}) {
				if ($bed_c{$chr}{$i}) {
					$status_2 = 2;
				}
			}
		}
		if ($status_1 != $status_2) {
			if ($status_1 == 1 and $status_2 == 2) {
				print OUT "$bed_a{$chr}{$i}\t$bed_b{$chr}{$i}\t$bed_c{$chr}{$i}\t$chr\t$i";
				$status_1 = 2;
				next;
			}
			if ($status_1 == 2 and $status_2 == 1) {
				print OUT "\t", $i - 1, "\n";
				$status_1 = 1;
				next;
			}
		}
	}
	print OUT "\t$end\n" if ($status_1 == 2);
}
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;

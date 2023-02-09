#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);

my $start_time = gettimeofday;
###########################################################################################################################
open (TXT, "<D:/research work/Takifugu/02.assembly/01_summary.txt") or die "$!";
open (OUT, ">D:/research work/Takifugu/02.assembly/02_beacon.txt") or die "$!";
###########################################################################################################################
my (%txt, %order, %context) = ();
while (<TXT>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my @txt = split (/\t/, $txt);
	push (@{$order{$txt[0]}}, $txt[6]) if (!$txt{$txt[0]}{$txt[6]});
	push (@{$txt{$txt[0]}{$txt[6]}}, $txt[7]);
	$context{$txt[0]}{$txt[6]}{$txt[7]} = $txt;
}
close (TXT);
###########################################################################################################################
foreach my $chr (sort {$a cmp $b} keys %order) {
	foreach my $scaffold (@{$order{$chr}}) {
		my @number = @{$txt{$chr}{$scaffold}};
		push (@number, 1000000);
		my @direction = ();
		my @status = ();
		for (my $i = 0; $i < $#number; $i++) {
			my $next_i = $i + 1;
			my $result = $number[$i] - $number[$next_i];
			if (abs($result) == 1) {
				if ($result < 0) {
					$direction[$i] = "+";
					$status[$i] = 1;
				} else {
					$direction[$i] = "-";
					$status[$i] = 1;
				}
			} else {
				my $last_i = $i - 1;
				if ($status[$last_i]) {
					$direction[$i] = $direction[$last_i];
					$status[$i] = 0;
				} else {
					$direction[$i] = "+";
					$status[$i] = 0;
				}
			}
		}
		for (my $i = 0; $i <= $#direction; $i++) {
			print OUT "$context{$chr}{$scaffold}{$number[$i]}\t$direction[$i]\t$status[$i]\n";
		}
	}
}
close (OUT);

printf "[total run time: %f s]\n", gettimeofday - $start_time;
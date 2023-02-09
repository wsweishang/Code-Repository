#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (INFSTA, "<$ARGV[0]") or die "$!"; #focus种群与背景种群1的Fst文件，需要使用去掉Fst负值的changedfst文件
open (INFSTB, "<$ARGV[1]") or die "$!"; #focus种群与背景种群2的Fst文件，需要使用去掉Fst负值的changedfst文件
open (INFSTC, "<$ARGV[2]") or die "$!"; #背景种群1与背景种群2的Fst文件，需要使用去掉Fst负值的changedfst文件
open (OUTPBS, ">$ARGV[3]") or die "$!"; #输出PBS文件
open (OUTPBE, ">$ARGV[4]") or die "$!"; #输出PBE文件
####################################################################################################
my (%fst_value, %common_windows) = ();
while (<INFSTA>) {
	chomp (my $a_data = $_);
	next if ($a_data =~ /^#.*/);
	my @a_data = split (/\t/, $a_data);
	$fst_value{"$a_data[0]\t$a_data[1]\t$a_data[2]"}{"a"} = -1 * log (1 - $a_data[4]); #自然对数
#	$fst_value{"$a_data[0]\t$a_data[1]\t$a_data[2]"}{"a"} = -1 * (log (1 - $a_data[4]) / log (10)); #以10为底的对数
	$common_windows{$a_data[0]}{$a_data[1]}{$a_data[2]}++;
}
close (INFSTA);

while (<INFSTB>) {
	chomp (my $b_data = $_);
	next if ($b_data =~ /^#.*/);
	my @b_data = split (/\t/, $b_data);
	$fst_value{"$b_data[0]\t$b_data[1]\t$b_data[2]"}{"b"} = -1 * log (1 - $b_data[4]); #自然对数
#	$fst_value{"$b_data[0]\t$b_data[1]\t$b_data[2]"}{"b"} = -1 * (log (1 - $b_data[4]) / log (10)); #以10为底的对数
	$common_windows{$b_data[0]}{$b_data[1]}{$b_data[2]}++;
}
close (INFSTB);

while (<INFSTC>) {
	chomp (my $c_data = $_);
	next if ($c_data =~ /^#.*/);
	my @c_data = split (/\t/, $c_data);
	$fst_value{"$c_data[0]\t$c_data[1]\t$c_data[2]"}{"c"} = -1 * log (1 - $c_data[4]); #自然对数
#	$fst_value{"$c_data[0]\t$c_data[1]\t$c_data[2]"}{"c"} = -1 * (log (1 - $c_data[4]) / log (10)); #以10为底的对数
	$common_windows{$c_data[0]}{$c_data[1]}{$c_data[2]}++;
}
close (INFSTC);
####################################################################################################
my (%c_med_value) = ();
print OUTPBS "#CHR\tSTART\tEND\tPBS\n";
foreach my $chr (sort {$a cmp $b} keys %common_windows) {
	foreach my $start (sort {$a <=> $b} keys %{$common_windows{$chr}}) {
		foreach my $end (sort {$a <=> $b} keys %{$common_windows{$chr}{$start}}) {
			next unless ($common_windows{$chr}{$start}{$end} == 3);
			my $pbs = ($fst_value{"$chr\t$start\t$end"}{"a"} + $fst_value{"$chr\t$start\t$end"}{"b"} - $fst_value{"$chr\t$start\t$end"}{"c"}) / 2;
			$fst_value{"$chr\t$start\t$end"}{"pbs"} = $pbs;
			print OUTPBS "$chr\t$start\t$end\t$pbs\n";
			push (@{$c_med_value{$chr}{"tmed"}}, $fst_value{"$chr\t$start\t$end"}{"c"});
			push (@{$c_med_value{$chr}{"pbsmed"}}, $pbs);
			$c_med_value{$chr}{"number"}++;
		}
	}
}
close (OUTPBS);
####################################################################################################
print OUTPBE "#CHR\tSTART\tEND\tPBE\n";
foreach my $chr (sort {$a cmp $b} keys %common_windows) {
	my ($tmed, $pbsmed) = ();
	if ($c_med_value{$chr}{"number"} % 2) {
		my @sort_tmed = sort {$a <=> $b} @{$c_med_value{$chr}{"tmed"}};
		my @sort_pbsmed = sort {$a <=> $b} @{$c_med_value{$chr}{"pbsmed"}};
		my $mid = int ($c_med_value{$chr}{"number"} / 2);
		$tmed = $sort_tmed[$mid];
		$pbsmed = $sort_pbsmed[$mid];
	} else {
		my @sort_tmed = sort {$a <=> $b} @{$c_med_value{$chr}{"tmed"}};
		my @sort_pbsmed = sort {$a <=> $b} @{$c_med_value{$chr}{"pbsmed"}};
		my $left = $c_med_value{$chr}{"number"} / 2;
		my $right = $left + 1;
		$tmed = ($sort_tmed[$left] + $sort_tmed[$right]) / 2;
		$pbsmed = ($sort_pbsmed[$left] + $sort_pbsmed[$right]) / 2;
	}
	foreach my $start (sort {$a <=> $b} keys %{$common_windows{$chr}}) {
		foreach my $end (sort {$a <=> $b} keys %{$common_windows{$chr}{$start}}) {
			next unless ($common_windows{$chr}{$start}{$end} == 3);
			my $pbe = $fst_value{"$chr\t$start\t$end"}{"pbs"} - ($fst_value{"$chr\t$start\t$end"}{"c"} * ($pbsmed / $tmed));
			print OUTPBE "$chr\t$start\t$end\t$pbe\n";
		}
	}
}
close (OUTPBE);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
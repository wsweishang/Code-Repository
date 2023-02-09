#!/usr/bin/perl

use strict;
use warnings;

open (INCOV,"<E:/grasscarp/protocol/CH_NC/CH_1_heart_R1_val_1_bismark_bt2_pe.deduplicated.bismark.cov") or die "$!";
open (OUT,">E:/grasscarp/protocol/CH_NC/ttttt.cov") or die "$!";
my $pace = 500;
my %methy = ();
my %unmethy = ();
my %max_len = ();

while (<INCOV>) {
	chomp (my $cov_data = $_);
	my @cov_data = split (/\t/,$cov_data);
	my $result = ($cov_data[1] - 1) / $pace;
	my $i = int $result;
	$methy{$cov_data[0]}{$i} += $cov_data[4];
	$unmethy{$cov_data[0]}{$i} += $cov_data[5];
	$max_len{$cov_data[0]} = $cov_data[1] unless (exists $max_len{$cov_data[0]});
	$max_len{$cov_data[0]} = $cov_data[1] if ($cov_data[1] >= $max_len{$cov_data[0]});
}
close (INCOV);

foreach my $key1 (sort {$a cmp $b} keys %unmethy) {
	foreach my $key2 (sort {$a <=> $b} keys %{$unmethy{$key1}}) {
		my $start = ($key2*$pace)+1;
		my $end = ($key2+1)*$pace;
		my $result = $methy{$key1}{$key2} / ($methy{$key1}{$key2} + $unmethy{$key1}{$key2});
		$result = sprintf ("%.3f",$result);
		my $remain = $max_len{$key1} - $start + 1;
		if ($remain <= $pace) {
			print OUT "$key1\t$start\t$max_len{$key1}\t$result\n";
		} else {
			print OUT "$key1\t$start\t$end\t$result\n";
		}
	}
}
close (OUT);
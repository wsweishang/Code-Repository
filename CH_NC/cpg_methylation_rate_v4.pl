#!/usr/bin/perl

use strict;
use warnings;

open (INCOV,"<E:/grasscarp/protocol/CH_NC/?????????") or die "$!";
open (INFASTA,"<E:/grasscarp/protocol/CH_NC/?????????") or die "$!";
open (OUT,">E:/grasscarp/protocol/CH_NC/???????????.cov") or die "$!";
my $pace = 500;
my %methy = ();
my %unmethy = ();

while (<INCOV>) {
	chomp (my $cov_data = $_);
	my @cov_data = split (/\t/,$cov_data);
	my $result = ($cov_data[1] - 1) / $pace;
	my $i = int $result;
	$methy{$cov_data[0]}{$i}{$cov_data[5]} += $cov_data[3];
	$unmethy{$cov_data[0]}{$i}{$cov_data[5]} += $cov_data[4];
}
close (INCOV);

my %length = ();
my $chr_ID = ();
while (<INFASTA>) {
	chomp (my $fasta_data = $_);
	if ($fasta_data =~ /^>(.*)/) {
		$chr_ID = $1;
	} else {
		my $length = length $fasta_data;
		$length{$chr_ID} = $length;
		undef $chr_ID;
	}
}
close (INFASTA);

my @c_context = qw/CG CHH CHG/;
foreach my $key1 (sort {$a cmp $b} keys %unmethy) {
	my $length = $length{$key1};
	my $end = ();
	for (my $i=0;$end<=$length;$i++) {
		my $start = ($i*$pace)+1;
		my $end = ($i+1)*$pace;
		my $remain = $length - $start + 1;
		if ($remain <= $pace) {
			print OUT "$key1\t$start\t$length";
		} else {
			print OUT "$key1\t$start\t$length";
		}
		foreach my $c_context (@c_context) {
			if (exists $methy{$key1}{$$i}{$c_context}) {
				my $result = $methy{$key1}{$$i}{$c_context} / ($methy{$key1}{$i}{$c_context} + $unmethy{$key1}{$i}{$c_context});
				$result = sprintf ("%.3f",$result);
				print OUT "\t$result";
			} else {
				print OUT "\t-1";
			}
		}
		print OUT "\n";
	}
}
close (OUT);


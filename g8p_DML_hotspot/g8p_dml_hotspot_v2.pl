#!/usr/bin/perl

use strict;
use warnings;

open (INMATRIX, "<E:/Grass carp/protocol/methylation/DSS/domestic_vs_foreign_DMLtest_LG01.txt") or die "$!";
open (OUT, ">E:/Grass carp/protocol/methylation/DSS/LG01_ggplot2.txt") or die "$!";

my $i = 1;
my $color = ();
print OUT "SNP\tCHR\tBP\tP\tColor\n";
while (<INMATRIX>) {
	chomp (my $matrix_data = $_);
	next if ($matrix_data =~ /^chr.*/);
	my @matrix_data = split (/\t/, $matrix_data);
	$matrix_data[0] =~ s/LG(.*)/$1/;
	if ($matrix_data[4] <= 0) {
		$color = "hypo";
	} else {
		$color = "hyper";
	}
	$matrix_data[4] = abs ($matrix_data[4]);
	print OUT "rs$i\t$matrix_data[0]\t$matrix_data[1]\t$matrix_data[4]\t$color\n";
	$i++;
}
close (OUT);

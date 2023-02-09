#!/usr/bin/perl

use strict;
use warnings;

open (INMATRIX, "<E:/Grass carp/protocol/methylation/DSS/LG/result/domestic_vs_foreign_DMLtest_LG02.txt") or die "$!";
open (INDML, "<E:/Grass carp/protocol/methylation/DSS/LG/result/domestic_vs_foreign_DML_LG02_delta02.txt") or die "$!";
open (OUT, ">E:/Grass carp/protocol/methylation/DSS/LG/result/LG02_main.txt") or die "$!";
open (OUTCOV, ">E:/Grass carp/protocol/methylation/DSS/LG/result/LG02_highlight.txt") or die "$!";

my %cov_data = ();
while (<INDML>) {
	chomp (my $cov_data = $_);
	next if ($cov_data =~ /^chr.*/);
	my @cov_data = split (/\t/, $cov_data);
	$cov_data{$cov_data[0]}{$cov_data[1]} = $cov_data[1];
}
close (INDML);

my $i = 1471570;
print OUT "SNP\tCHR\tBP\tP\n";
while (<INMATRIX>) {
	chomp (my $matrix_data = $_);
	next if ($matrix_data =~ /^chr.*/);
	my @matrix_data = split (/\t/, $matrix_data);
	if (exists $cov_data{$matrix_data[0]}{$matrix_data[1]}) {
		print OUTCOV '"'."rs$i".'", ';
	}
	$matrix_data[0] =~ s/LG(.*)/$1/;
	$matrix_data[4] = abs ($matrix_data[4]);
	$matrix_data[4] = $matrix_data[4] * 1000;
	print OUT "rs$i\t$matrix_data[0]\t$matrix_data[1]\t$matrix_data[4]\n";
	$i++;
}
close (INMATRIX);
close (OUT);
close (OUTCOV);

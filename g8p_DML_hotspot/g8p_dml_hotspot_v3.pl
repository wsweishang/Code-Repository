#!/usr/bin/perl

use strict;
use warnings;

open (INDMLTEST, "<E:/Grass carp/protocol/methylation/DSS/DML_hotspot_manhattan/domestic_vs_foreign_DMLtest_LG02.txt") or die "$!";
open (INDML, "<E:/Grass carp/protocol/methylation/DSS/DML_hotspot_manhattan/domestic_vs_foreign_DML_LG02.txt") or die "$!";
open (OUT, ">E:/Grass carp/protocol/methylation/DSS/DML_hotspot_manhattan/LG02_ggplot2_v2.txt") or die "$!";

my %dml_data = ();
while (<INDML>) {
	chomp (my $dml_data = $_);
	next if ($dml_data =~ /^chr.*/);
	my @dml_data = split (/\t/, $dml_data);
	$dml_data{$dml_data[0]}{$dml_data[1]} = "1";
}
close (INDML);

my $color = ();
print OUT "Chr\tBaseSite\tBaseDelta\tColor\n";
while (<INDMLTEST>) {
	chomp (my $matrix_data = $_);
	next if ($matrix_data =~ /^chr.*/);
	my @matrix_data = split (/\t/, $matrix_data);
	if ($matrix_data[4] <= 0) {
		if (exists $dml_data{$matrix_data[0]}{$matrix_data[1]}) {
			$color = "dmlhypo";
		} else {
			$color = "hypo";
		}
		
	} else {
		if (exists $dml_data{$matrix_data[0]}{$matrix_data[1]}) {
			$color = "dmlhyper";
		} else {
			$color = "hyper";
		}
		
	}
	$matrix_data[4] = abs ($matrix_data[4]);
	print OUT "$matrix_data[0]\t$matrix_data[1]\t$matrix_data[4]\t$color\n";
	undef ($color);
}
close (INDMLTEST);
close (OUT);

#!/usr/bin/perl

use strict;
use warnings;

open (INCOV, "<D:/research work/Moso_huaguijia/anjimaozhu_S8S11_R1_bismark_bt2_pe.bismark.cov") or die "$!";
open (OUT, ">D:/research work/Moso_huaguijia/anjimaozhu_cov.txt") or die "$!";

my %cov_data = ();
while (<INCOV>) {
	chomp (my $cov_data = $_);
	my @cov_data = split (/\t/, $cov_data);
	(my $chr = $cov_data[0]) =~ s/^hic_scaffold_([0-9]+)/$1/;
	my $pos = $cov_data[1];
	my $N = $cov_data[4] + $cov_data[5];
	my $P = $cov_data[4];
	$cov_data{$chr}{$pos} = "$N\t$P";
}
close (INCOV);

print OUT "chr\tpos\tN\tX\n";
foreach my $chr (sort {$a <=> $b} keys %cov_data) {
	foreach my $pos (sort {$a <=> $b} keys %{$cov_data{$chr}}) {
		print OUT "chr$chr\t$pos\t$cov_data{$chr}{$pos}\n";
	}
}
close (OUT);






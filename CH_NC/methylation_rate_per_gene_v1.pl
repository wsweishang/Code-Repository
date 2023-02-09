#!/usr/bin/perl

use strict;
use warnings;

open (INGFF,"<$ARGV[0]") or die "$!";
open (INCOV,"<$ARGV[1]") or die "$!";
open (OUT,">$ARGV[2]") or die "$!";

my %cov_data = ();
while (<INCOV>) {
	chomp (my $cov_data = $_);
	my @cov_data = split (/\t/,$cov_data);
	$cov_data{$cov_data[0]}{$cov_data[1]}{"methyled"} = $cov_data[4];
	$cov_data{$cov_data[0]}{$cov_data[1]}{"unmethyled"} = $cov_data[5];
}
close (INCOV);

while (<INGFF>) {
	chomp (my $gff_data = $_);
	my @gff_data = split (/\t/,$gff_data);
	my $gene_ID = $gff_data[0];
	my $chr_ID = $gff_data[1];
	my $orientation = $gff_data[4];
	my $start = $gff_data[2];
	$start = $gff_data[2] -1000 if ($orientation eq "+");
	my $end = $gff_data[3];
	$end = $gff_data[3] + 1000 if ($orientation eq "-");
	my $methyl_count = 0;
	my $unmethyl_count = 1;
	for (my $i = $start;$i <= $end;$i++) {
		if (exists $cov_data{$chr_ID}{$i}) {
			$methyl_count += $cov_data{$chr_ID}{$i}{"methyled"};
			$unmethyl_count += $cov_data{$chr_ID}{$i}{"unmethyled"};
		}
		last if ($i > $end);
	}
	my $result = $methyl_count / ($methyl_count + $unmethyl_count);
	$result = sprintf ("%.3f",$result);
	$unmethyl_count = 0 if ($methyl_count == 0 and $unmethyl_count == 1);
	print OUT "$gff_data\t$methyl_count\t$unmethyl_count\t$result\n";
}
close (OUT);



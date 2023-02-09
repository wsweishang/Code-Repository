#!/usr/bin/perl

use strict;
use warnings;

open (INTXT, "<$ARGV[0]") or die "$!";
open (INOT, "<$ARGV[1]") or die "$!";
open (INOB, "<$ARGV[2]") or die "$!";
open (OUT, ">$ARGV[3]") or die "$!";

my %ot_data = ();
while (<INOT>) {
	chomp (my $ot_data = $_);
	my @ot_data = split (/\t/,$ot_data);
	$ot_data{$ot_data[2]}{$ot_data[3]}{$ot_data[1]}++;
}
close (INOT);

my %ob_data = ();
while (<INOB>) {
	chomp (my $ob_data = $_);
	my @ob_data = split (/\t/,$ob_data);
	$ob_data{$ob_data[2]}{$ob_data[3]}{$ob_data[1]}++;
}
close (INOB);

while (<INTXT>) {
	chomp (my $gff_data = $_);
	my @gff_data = split (/\t/,$gff_data);
	my $gene_ID = $gff_data[0];
	my $chr_ID = $gff_data[1];
	my $orientation = $gff_data[4];
	my $result = ();
	my $methyl_count = 0;
	my $unmethyl_count = 0;
	if ($orientation eq "+") {
		my $start = $gff_data[2] - 1000;
		my $end = $gff_data[3];
		for (my $i = $start;$i <= $end;$i++) {
				$methyl_count += $ot_data{$chr_ID}{$i}{"+"} if (exists $ot_data{$chr_ID}{$i}{"+"});
				$unmethyl_count += $ot_data{$chr_ID}{$i}{"-"} if (exists $ot_data{$chr_ID}{$i}{"-"});
		}
	} elsif ($orientation eq "-") {
		my $start = $gff_data[2];
		my $end = $gff_data[3] + 1000;
		for (my $i = $start;$i <= $end;$i++) {
				$methyl_count += $ob_data{$chr_ID}{$i}{"+"} if (exists $ob_data{$chr_ID}{$i}{"+"});
				$unmethyl_count += $ob_data{$chr_ID}{$i}{"-"} if (exists $ob_data{$chr_ID}{$i}{"-"});
		}
	}
	if ($methyl_count == 0 and $unmethyl_count == 0) {
		$result = 0;
	} else {
		$result = $methyl_count / ($methyl_count + $unmethyl_count);
		$result = sprintf ("%.3f",$result);
	}
	print OUT "$gff_data\t$methyl_count\t$unmethyl_count\t$result\n";
}
close (INTXT);
close (OUT);



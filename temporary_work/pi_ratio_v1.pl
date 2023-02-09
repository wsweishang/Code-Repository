#!/usr/bin/perl

use strict;
use warnings;

open (INPIA, "<$ARGV[0]") or die "$!";
open (INPIB, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";

my %range = ();
my %pia_data = ();
while (<INPIA>) {
	chomp (my $pia_data = $_);
	next if ($pia_data =~ /^CHROM.*/);
	my @pia_data = split (/\t/, $pia_data);
	$range{"$pia_data[0]\t$pia_data[1]\t$pia_data[2]"} = 1;
	$pia_data{"$pia_data[0]\t$pia_data[1]\t$pia_data[2]"} = $pia_data[4];
}
close (INPIA);

my %pib_data = ();
while (<INPIB>) {
	chomp (my $pib_data = $_);
	next if ($pib_data =~ /^CHROM.*/);
	my @pib_data = split (/\t/, $pib_data);
	$range{"$pib_data[0]\t$pib_data[1]\t$pib_data[2]"} = 1;
	$pib_data{"$pib_data[0]\t$pib_data[1]\t$pib_data[2]"} = $pib_data[4];
}
close (INPIB);

foreach my $range (sort keys %range) {
	if ($pia_data{$range}) {
		if ($pib_data{$range}) {
			my $result = $pia_data{$range}/$pib_data{$range};
			print OUT "$range\t$pia_data{$range}\t$pib_data{$range}\t$result\n";
		} else {
			print OUT "$range\t$pia_data{$range}\tNA\tNA\n";
		}
	} else {
		print OUT "$range\tNA\t$pib_data{$range}\tNA\n";
	}
}
close (OUT);











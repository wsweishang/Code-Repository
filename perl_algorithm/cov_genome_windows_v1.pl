#!/usr/bin/perl

use strict;
use warnings;

if (! defined($ARGV[2])){
	print STDERR "\nGenerate overlapping windows of a desired genome as a BED file\n";
	print STDERR "USAGE: $0 chromInfoFile windowWidth windowOverlap > out.bed\n";
	print STDERR "Ex: $0 TAIR10/chromInfo.txt 1000 100 > TAIR10_1000_100.bed\n";
	print STDERR "Note: chr lengths come from chromInfo.txt\n\n";
	exit;
}

# If there's less than a window's width at the end, should we still print it?
my $PRINT_REMAINING = 1;

# Defined by user
my $chromInfo = $ARGV[0];	# This anno file is needed to get chr lengths
my $windowWidth = $ARGV[1];
my $windowOverlap = $ARGV[2];

my %chr2length = ();
open (CHROM_INFO, $chromInfo) || die "\nCannot open $chromInfo for reading: $! -- Do you need to download this file?\n\n";
while (<CHROM_INFO>) {
	chomp;
	my ($chr, $chrLength) = split (/\t/, $_);
	$chr2length{$chr} = $chrLength;
}

# Go through all the chrs
foreach my $chr (sort keys %chr2length) {
	# Iterate through $windowWidth - $windowOverlap
	for (my $i = 0; $i <= $chr2length{$chr}; $i+= $windowWidth - $windowOverlap) {
		my $start = $i;
		my $end = $start + $windowWidth;
		if ($end <= $chr2length{$chr}) {
			print "$chr\t$start\t$end\n";
		} elsif ($PRINT_REMAINING) {
			$end = $chr2length{$chr};
			print "$chr\t$start\t$end\n";
		}
	}
}
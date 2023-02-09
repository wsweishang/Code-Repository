#!/usr/bin/perl

use strict;
use warnings;

my @pathes = glob "D:/research' 'work/Grass_carp/Methylation/dmr/newcluster/*.txt";

my (%header, %txt) = ();
foreach my $path (@pathes) {
	$path =~ /.*\/(.*)_(LG\d+)_(.*).txt/;
	my $group = $1;
	my $chr = $2;
	my $gh = $3;
	open (IN, "<$path") or die "$!";
	while (<IN>) {
		chomp (my $txt = $_);
		if ($txt =~ /^chr.*/) {
			$header{$group}{$gh} = $txt;
			next;
		} else {
			my @txt = split (/\t/, $txt);
			push (@{$txt{$group}{$gh}{$chr}}, $txt);
		}
	}
}
close (IN);

foreach my $group (keys %txt) {
	foreach my $gh (keys %{$txt{$group}}) {
		open (OUT, ">D:/${group}_${gh}.txt") or die "$!";
		print OUT "#$header{$group}{$gh}\n";
		foreach my $chr (sort {$a cmp $b} keys %{$txt{$group}{$gh}}) {
			map {print OUT "$_\n"} @{$txt{$group}{$gh}{$chr}};
		}
	}
}
close (OUT);







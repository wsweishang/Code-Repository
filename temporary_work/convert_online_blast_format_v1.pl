#!/usr/bin/perl

use strict;
use warnings;

open (INTXT, "<D:/research work/Grass carp/SLAF/online blast with DR/eastasia_vs_southasia_AF005AN80FS60DP80_100kb_top005_gene_2.txt") or die "$!";
open (INXML, "<D:/research work/Grass carp/SLAF/online blast with DR/eastasia_vs_southasia_AF005AN80FS60DP80_100kb_top005_gene.xml") or die "$!";
open (OUT, ">D:/t.txt") or die "$!";

my (%xml, $que_id, $sub_id) = ();
while (<INXML>) {
	chomp (my $xml = $_);
	if ($xml =~ /<Iteration_query-def>(.*)<\/Iteration_query-def>/) {
		$que_id = $1;
		next;
	} 
	if ($xml =~ /<Hit_id>.*\|(.*)\|<\/Hit_id>/) {
		$sub_id = $1;
		next;
	}
	if ($xml =~ /<Hit_def>(.*)<\/Hit_def>/) {
		$xml{$que_id}{$sub_id} = $1;
		undef $sub_id;
		next;
	}
}
close (INXML);

while (<INTXT>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	next unless ($txt);
	my @txt = split (/\t/, $txt);
	if (exists $xml{$txt[0]}{$txt[1]}) {
		print OUT "$txt\t$xml{$txt[0]}{$txt[1]}\n";
	} else {
		print OUT "$txt\tNA\n";
	}
}
close (INTXT);
close (OUT);
















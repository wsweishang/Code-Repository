#!/usr/bin/perl

use strict;
use warnings;

open (INDMR, "<$ARGV[0]") or die "$!";
open (INGFF, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";

my %gff = ();
while (<INGFF>) {
	chomp (my $gff = $_);
	next if ($gff =~ /^#.*/);
	my @gff = split (/\t/, $gff);
	if ($gff[2] eq "gene") {
		(my $gene_name = $gff[8]) =~ s/Name=([a-zA-Z0-9_]+)/$1/;
		my $left = $gff[3];
		my $right = $gff[4];
		if ($gff[6] eq "+") {
			if ($gff[3] >= 1000) {
				$left = $gff[3] - 1000;
			} else {
				print "error";
			}
		} elsif ($gff[6] eq "-") {
			$right = $gff[4] + 1000;
		} else {
			print "error";
		}
		$gff{$gff[0]}{$left}{$right} = "$gene_name\t$gff";
	}
}
close (INGFF);

print OUT "#chr\tstart\tend\tlength\tnCG\tmeanMethy1\tmeanMethy2\tdiff.Methy\tareaStat\tgene name\tgff\n";
while (<INDMR>) {
	chomp (my $dmr = $_);
	next if ($dmr =~ /^#.*/);
	my @dmr = split (/\t/, $dmr);
	my $dmr_left = $dmr[1] - 1000;
	my $dmr_right = $dmr[2] + 1000;
	foreach my $gene_left (sort {$a <=> $b} keys %{$gff{$dmr[0]}}) {
		foreach my $gene_right (sort {$a <=> $b} keys %{$gff{$dmr[0]}{$gene_left}}) {
			my $a = $dmr_left - $gene_right;
			my $b = $dmr_right - $gene_left;
			if ($a <= 0 and $b >= 0) {
				print OUT "$dmr\t$gff{$dmr[0]}{$gene_left}{$gene_right}\n";
			}
		}
	}
}
close (INDMR);
close (OUT);






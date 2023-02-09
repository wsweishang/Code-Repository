#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (INLIST, "<D:/path.txt") or die "$!";
open (OUT, ">D:/out.txt") or die "$!";

my %path = ();
while (<INLIST>) {
	chomp (my $list = $_);
	next if ($list =~ /^#.*/);
	my @list = split (/\t/, $list);
	$path{$list[0]} = $list[1];
}
close (INLIST);

my ($status, @n_snps, %dist) = ();

foreach my $parameter (keys %path) {
	open (INDIST, "<$path{$parameter}") or die "$!";
	while (<INDIST>) {
		chomp (my $dist = $_);
		next if ($dist =~ /^[#n].*/);
		if ($dist =~ /BEGIN snps_per_loc_postfilters/) {
			$status = 1;
			next;
		}
		if ($dist =~ /END snps_per_loc_postfilters/) {
			undef $status;
			next;
		}
		if ($status) {
			my @dist = split (/\t/, $dist);
			$dist{$parameter}{"n_snps"} += ($dist[0] * $dist[1]);
			$dist[0] = ($dist[0] >= 11) ? 11 : $dist[0];
			$n_snps[$dist[0]] = $dist[0];
			$dist{$parameter}{"n_assembled_loci"} += $dist[1];
			$dist{$parameter}{"n_snps_per_loci"}{$dist[0]} += $dist[1];
			$dist{$parameter}{"n_polymorphic_loci"} += $dist[1] if ($dist[0] != 0);
		}
	}
}
close (INDIST);

print OUT "#parameters\t" , join ("\t", @n_snps) , "\tn_assembled_loci\tn_polymorphic_loci\tn_snps\n";
foreach my $parameter (sort {$a cmp $b} keys %dist) {
	print OUT "$parameter\t";
	foreach my $n_snps (@n_snps) {
		if (exists $dist{$parameter}{"n_snps_per_loci"}{$n_snps}) {
			my $ratio = $dist{$parameter}{'n_snps_per_loci'}{$n_snps} / $dist{$parameter}{'n_assembled_loci'};
			$ratio = sprintf ("%0.4f", $ratio);
			print OUT "$ratio\t";
		} else {
			print OUT "0\t";
		}
	}
	print OUT "$dist{$parameter}{'n_assembled_loci'}\t$dist{$parameter}{'n_polymorphic_loci'}\t$dist{$parameter}{'n_snps'}\n";
}
close (OUT);







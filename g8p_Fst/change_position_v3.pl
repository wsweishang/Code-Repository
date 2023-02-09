#!/usr/bin/perl

use strict;
use warnings;

open (INTXT, "<E:/GrassCarp_Fst_Pi_cultivation_divides_wild_0.99_sig_region.txt") or die "$!";
open (INLG, "<E:/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt") or die "$!";
open (OUT, ">E:/GrassCarp_Fst_Pi_cultivation_divides_wild_0.99_sig_region_changedposition.txt") or die "$!";

my %txt = ();
my $title = ();
while (<INTXT>) {
	chomp (my $txt = $_);
	if ($txt =~ /^Chr.*/) {
		$title = $txt;
		next;
	}
	my @txt = split (/\t/, $txt);
	push (@{$txt{$txt[0]}}, $txt);
}
close (INTXT);

print OUT "$title\n";
while (<INLG>) {
	chomp (my $lg = $_);
	next if ($lg =~ /^LG.*/);
	my @lg = split (/\t/, $lg);
	if ($lg[-1] eq "+") {
		foreach my $txt (@{$txt{$lg[1]}}) {
			my @txt = split (/\t/, $txt);
			$txt[0] = "LG$lg[0]";
			$txt[1] = $txt[1] + $lg[3] - 1;
			$txt[2] = $txt[2] + $lg[3] - 1;
			print OUT join ("\t", @txt) , "\n";
		}
	} elsif ($lg[-1] eq "-") {
		foreach my $txt (@{$txt{$lg[1]}}) {
			my @txt = split (/\t/, $txt);
			$txt[0] = "LG$lg[0]";
			my $start = ($lg[2] - $txt[2]) + $lg[3];
			my $end = ($lg[2] - $txt[1]) + $lg[3];
			$txt[1] = $start;
			$txt[2] = $end;
			print OUT join ("\t", @txt) , "\n";
		}
	} else {
		print "error : can not find \$lg[-1]\n";
	}
}
close (INLG);
close (OUT);

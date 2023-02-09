#!/usr/bin/perl

use strict;
use warnings;

open (INTXT, "<E:/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt") or die "$!";
open (INFST, "<E:/GrassCarp_Fst_Pi_cultivation_divides_wild_0.99_sig_region.txt") or die "$!";
open (OUT, ">E:/GrassCarp_Fst_Pi_cultivation_divides_wild_0.99_sig_region_changedposition.txt") or die "$!";

my %order = ();
while (<INTXT>) {
	chomp (my $txt_data = $_);
	next if ($txt_data =~ /^LG.*/);
	my @txt_data = split (/\t/, $txt_data);
	$order{$txt_data[1]}{"chr"} = $txt_data[0];
	$order{$txt_data[1]}{"length"} = $txt_data[2];
	$order{$txt_data[1]}{"start"} = $txt_data[3];
	$order{$txt_data[1]}{"orientation"} = $txt_data[4];
}
close (INTXT);

while (<INFST>) {
	chomp (my $fst_data = $_);
	next if ($fst_data =~ /^Chr.*/);
	my @fst_data = split (/\t/, $fst_data);
	if ($order{$fst_data[0]}{"orientation"} eq "+") {
		$fst_data[0] = "LG$order{$fst_data[0]}{'chr'}";
		$fst_data[1] = $order{$fst_data[0]}{"start"} + $fst_data[1] - 1;
		$fst_data[2] = $order{$fst_data[0]}{"start"} + $fst_data[2] - 1;
		print OUT join ("\t", @fst_data) , "\n";
	} else {
		$fst_data[0] = "LG$order{$fst_data[0]}{'chr'}";
		my $end = $order{$fst_data[0]}{"start"} + $order{$fst_data[0]}{"length"} - $fst_data[1];
		my $start = $order{$fst_data[0]}{"start"} + $order{$fst_data[0]}{"length"} - $fst_data[2];
		$fst_data[1] = $start;
		$fst_data[2] = $end;
		print OUT join ("\t", @fst_data) , "\n";
	}
}
close (INFST);
close (OUT);


#!/usr/bin/perl

use strict;
use warnings;

open (INFST, "<D:/research work/Grass carp/SLAF/Statistic/AN4FS10DP10/fst/farmed_vs_wild_AN4FS10DP10_10kb_10kb_changed.windowed.weir.fst") or die "$!";
open (INPIRATIO, "<D:/research work/Grass carp/SLAF/Statistic/AN4FS10DP10/piratio/farmed_vs_wild_AN4FS10DP10_10kb.windowed.piratio") or die "$!";
open (OUT, ">D:/t.txt") or die "$!";

my %site_list = ();
my %fst_data = ();
while (<INFST>) {
	chomp (my $fst_data = $_);
	next if ($fst_data !~ /^LG.*/);
	my @fst_data = split (/\t/, $fst_data);
	$fst_data{"$fst_data[0]\t$fst_data[1]\t$fst_data[2]"} = $fst_data[5];
	my $gh = ($fst_data[1] + $fst_data[2]) / 2;
	$site_list{$fst_data[0]}{$gh} = "$fst_data[0]\t$fst_data[1]\t$fst_data[2]";
}
close (INFST);

my %piratio_data = ();
while (<INPIRATIO>) {
	chomp (my $piratio_data = $_);
	next if ($piratio_data !~ /^LG.*/);
	my @piratio_data = split (/\t/, $piratio_data);
	if ($piratio_data[5] eq "NA") {
		$piratio_data{"$piratio_data[0]\t$piratio_data[1]\t$piratio_data[2]"} = "";
	} else {
		$piratio_data{"$piratio_data[0]\t$piratio_data[1]\t$piratio_data[2]"} = $piratio_data[5];
	}
	my $fh = ($piratio_data[1] + $piratio_data[2]) / 2;
	$site_list{$piratio_data[0]}{$fh} = "$piratio_data[0]\t$piratio_data[1]\t$piratio_data[2]";
}
close (INPIRATIO);

foreach my $chr (sort keys %site_list) {
	foreach my $middle_site (sort {$a <=> $b} keys %{$site_list{$chr}}) {
		my $range = $site_list{$chr}{$middle_site};
		print OUT "$range";
		if (exists $fst_data{$range}) {
			print OUT "\t$fst_data{$range}";
		} else {
			print OUT "\t";
		}
		if (exists $piratio_data{$range}) {
			print OUT "\t$piratio_data{$range}";
		} else {
			print OUT "\t";
		}
		print OUT "\n";
	}
}
close (OUT);


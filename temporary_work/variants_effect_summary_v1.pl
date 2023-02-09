#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;

open (FILEPATH, "<D:/research work/Grass_carp/Gene/workshop_filepath_list.txt") or die "$!";
open (KEGG, "<D:/research work/Grass_carp/Gene/ko00001.keg") or die "$!";
open (OUT, ">D:/research work/Grass_carp/Gene/ko_list.txt") or die "$!";

my (@order, %ortholog, %gene) = ();
while (<FILEPATH>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my @txt = split (/\t/, $txt);
	push (@order, $txt[0]);
	open (GENE, "<$txt[2]") or die "$!";
	while (<GENE>) {
		chomp (my $gene = $_);
		next if ($gene =~ /^#.*/);
		my @gene = split (/\t/, $gene);
		$gene{$gene[0]}{"k_number"} = $gene[1];
		$gene{$gene[0]}{$txt[0]} = 1;
	}
	close (GENE);
}
close (FILEPATH);

my ($pathway, %kegg) = ();
while (<KEGG>) {
	chomp (my $kegg = $_);
	if ($kegg =~ /^C\s+(\d+)\s+(.*)/) {
		$pathway = $2;
	} elsif ($kegg =~ /^D\s+(\S+)\s+(.*);\s+(.*)/) {
		$kegg{$1}{"gene_id"} = $2;
		$kegg{$1}{"gene_description"} = $3;
		push (@{$kegg{$1}{"pathway"}}, $pathway);
	}
}
close (KEGG);

foreach my $gene (sort {$a cmp $b} keys %gene) {
	my $k_number = $gene{$gene}{"k_number"};
	print OUT "$gene\t$k_number\t";
	if (exists $kegg{$k_number}) {
		print OUT "$kegg{$k_number}{'gene_id'}\t$kegg{$k_number}{'gene_description'}\t";
		print OUT join ("|", @{$kegg{$k_number}{"pathway"}}), "\t";
	} else {
		print OUT "\t\t\t";
		print "$gene\t$k_number\n";
	}
	foreach my $order (@order) {
		if (exists $gene{$gene}{$order}) {
			print OUT "\t$order";
		} else {
			print OUT "\t";
		}
	}
	print OUT "\n";
}
close (OUT);




printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open(INFASTA, "<D:/research work/GlimmerHMM/zps/ca_zps2.txt.fa") or die "$!";
open(INTXT, "<D:/research work/GlimmerHMM/GlimmerHMM_prediction/ca_zps2_official_zebrafish_prediction.txt") or die "$!";
open(OUT, ">D:/t.fa") or die "$!";

my ($gene_name, %gene_seq) = ();
while (<INFASTA>) {
	chomp (my $data = $_);
	if ($data =~ /^>(.*)/) {
		$gene_name = $1;
	} else {
		$gene_seq{$gene_name} .= $data;
	}
}
close (INFASTA);

my ($gene_id, @gene_order, %gene) = ();
while (<INTXT>) {
	chomp (my $data = $_);
	next unless ($data);
	$data =~ s/^\s+//g;
	my @data = split(/\s+/, $data);
	if ($data =~ /^Sequence name: (.*)/) {
		$gene_id = $1;
		push (@gene_order, $gene_id);
		next;
	}
	if ($data[0] =~ /^\d+.*/) {
		push (@{$gene{$gene_id}{$data[0]}}, "$data[4]_$data[5]");
	}
}
close (INTXT);

my %gene_region = ();
foreach my $gene (@gene_order) {
	my @temp = ();
	map {push (@temp, join ("|", @{$gene{$gene}{$_}}))} sort {$a <=> $b} keys %{$gene{$gene}};
	$gene_region{$gene} = join ("_", @temp);
}

foreach my $gene (@gene_order) {
	my @gene_region = split (/\|/, $gene_region{$gene});
	my ($exon_seq, @temp) = ();
	foreach my $exon_region (@gene_region) {
		my @exon_region = split (/_/, $exon_region);
		@exon_region = sort @exon_region;
		my $left = $exon_region[0];
		my $right = $exon_region[-1];
		
		push (@temp, "${left}_$right");
		
		my $start = $left - 1;
		my $length = $right - $start + 1;
		$exon_seq .= substr ($gene_seq{$gene}, $start, $length);
	}
	print OUT ">$gene\t", join ("|", @temp), "\n";
	print OUT "$exon_seq\n";
}
close (OUT);


































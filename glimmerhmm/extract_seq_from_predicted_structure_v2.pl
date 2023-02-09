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

my ($gene_id, @gene_order, %gene, %stat) = ();
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
		push (@{$gene{$gene_id}{$data[2]}{$data[0]}}, "$data[4]_$data[5]");
		$stat{$gene_id}{$data[2]}++;
	}
}
close (INTXT);

my %gene_region = ();
foreach my $gene (@gene_order) {
	my @temp = ();	
	my @stat = sort {$stat{$gene}{$b} <=> $stat{$gene}{$a}} keys %{$stat{$gene}};
	map {push (@temp, join ("|", @{$gene{$gene}{$stat[0]}{$_}}))} sort {$a <=> $b} keys %{$gene{$gene}{$stat[0]}};
	$gene_region{$gene}{"seq"} = join ("_", @temp);
	$gene_region{$gene}{"direction"} = $stat[0];
	print "$gene, $stat[0]\n";
}

foreach my $gene (@gene_order) {
	my @gene_region = split (/\|/, $gene_region{$gene}{"seq"});
	my $gene_direction = $gene_region{$gene}{"direction"};
	my ($exon_seq, @temp) = ();
	foreach my $exon_region (@gene_region) {
		my @exon_region = split (/_/, $exon_region);
		@exon_region = sort {$a <=> $b} @exon_region;
		my $left = $exon_region[0];
		my $right = $exon_region[-1];
		push (@temp, "${left}_$right");
		my $start = $left - 1;
		my $length = $right - $left + 1;
		my $seq = substr ($gene_seq{$gene}, $start, $length);
		if ($gene_direction eq "-") {
			$seq = reverse $seq;
			$seq =~ tr/ATCG/TAGC/;
		}
		$exon_seq .= $seq;
	}
	print OUT ">$gene\t$gene_direction\t", join ("|", @temp), "\n";
	print OUT "$exon_seq\n";
}
close (OUT);


































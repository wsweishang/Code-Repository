#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Statistics::Descriptive;
use Statistics::Robust::Scale qw(MAD);
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (INANNOTATION, "<D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/methy_gene_table/gene_name_list.txt") or die "$!";
open (INENRICHMENT, "<D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/methy_gene_table/methy_gene_list_v2.txt") or die "$!";
open (OUT, ">D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/methy_gene_table/t.txt") or die "$!";

my %gene_annotation = ();
while (<INANNOTATION>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	$gene_annotation{$data[0]} = $data[2];
}
close (INANNOTATION);

my %gene_enrichment = ();
while (<INENRICHMENT>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	my @gene_id = split (/\|/, $data[8]);
	foreach my $gene_id (@gene_id) {
#		$gene_enrichment{$data[0]}{$gene_id}{"GO_term"}{$data[1]} = 1;
#		$gene_enrichment{$data[0]}{$gene_id}{"GO_id"}{$data[3]} = 1;
		$gene_enrichment{$data[0]}{$gene_id}{$data[1]} = $data[3];
	}
}
close (INENRICHMENT);

foreach my $cluster (sort {$a cmp $b} keys %gene_enrichment) {
	foreach my $id (sort {$a cmp $b} keys %{$gene_enrichment{$cluster}}) {
#		my @go_term = sort {$a cmp $b} keys %{$gene_enrichment{$cluster}{$id}{"GO_term"}};
#		my @go_id = sort {$a cmp $b} keys %{$gene_enrichment{$cluster}{$id}{"GO_id"}};
		my @temp = ();
		foreach my $goterm (sort {$a cmp $b} keys %{$gene_enrichment{$cluster}{$id}}) {
			my $temp = "$goterm ($gene_enrichment{$cluster}{$id}{$goterm})";
			push (@temp, $temp);
		}
		if ($gene_annotation{$id}) {
#			print OUT "$cluster\t$id\t$gene_annotation{$id}\t", join (" | ", @go_term), "\t", join (" | ", @go_id), "\n";
			print OUT "$cluster\t$id\t$gene_annotation{$id}\t", join (" | ", @temp), "\n";
		} else {
#			print OUT "$cluster\t$id\tNA\t", join ("\t", @{$gene_enrichment{$cluster}{$id}{"GO"}}), "\t", join (" | ", @go_id), "\n";
			print OUT "$cluster\t$id\tNA\t", join (" | ", @temp), "\n";
		}
	}
}
close (OUT);

#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
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
my @cluster = qw/IN_vs_TJ IN_vs_WZ TJ_vs_IN TJ_vs_WZ WZ_vs_IN WZ_vs_TJ/;
my %selected_region = ();
foreach my $cluster (@cluster) {
	open (INOVERLAP, "<D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/selected_gene_manhattan_distribution/${cluster}_reseq_50kb_2kb_top005_gene.overlap") or die "$!";
	
	my %temp = ();
	
	while (<INOVERLAP>) {
		chomp (my $data = $_);
		next if ($data =~ /^#.*/);
		my @data = split (/\t/, $data);
		next unless ($data[2] eq "gene");
		$data[8] =~ /.*Name=([0-9a-zA-Z_]+).*/;
		my $gene_id = $1;
		push (@{$temp{$gene_id}{$data[9]}{"start"}}, $data[10]);
		push (@{$temp{$gene_id}{$data[9]}{"end"}}, $data[11]);
	}
	close (INOVERLAP);
	
	foreach my $gene_id (sort {$a cmp $b} keys %temp) {
		foreach my $chr (sort {$a cmp $b} keys %{$temp{$gene_id}}) {
			my @start = @{$temp{$gene_id}{$chr}{"start"}};
			my @end = @{$temp{$gene_id}{$chr}{"end"}};
			my $start = $start[0];
			my $end = $end[-1];
			$selected_region{$cluster}{$gene_id} = $chr . "\t" . $start . "_" . $end;
		}
	}
}

open (INANNOTATION, "<D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/methy_gene_table/gene_name_list.txt") or die "$!";
open (INENRICHMENT, "<D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/methy_gene_table/methy_gene_list_v2.txt") or die "$!";
open (OUT, ">D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/methy_gene_table/tt.txt") or die "$!";

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
		$gene_enrichment{$data[0]}{$gene_id}{$data[1]} = $data[3];
	}
}
close (INENRICHMENT);

foreach my $cluster (sort {$a cmp $b} keys %gene_enrichment) {
	foreach my $id (sort {$a cmp $b} keys %{$gene_enrichment{$cluster}}) {
		my @temp = ();
		foreach my $goterm (sort {$a cmp $b} keys %{$gene_enrichment{$cluster}{$id}}) {
			my $temp = "$goterm ($gene_enrichment{$cluster}{$id}{$goterm})";
			push (@temp, $temp);
		}
		if ($gene_annotation{$id}) {
			if ($selected_region{$cluster}{$id}) {
				print OUT "$cluster\t$id\t$gene_annotation{$id}\t", join (" | ", @temp), "\t$selected_region{$cluster}{$id}\n";
			} else {
				print OUT "$cluster\t$id\t$gene_annotation{$id}\t", join (" | ", @temp), "\tNA\n";
			}
		} else {
			if ($selected_region{$id}) {
				print OUT "$cluster\t$id\tNA\t", join (" | ", @temp), "\t$selected_region{$cluster}{$id}\n";
			} else {
				print OUT "$cluster\t$id\tNA\t", join (" | ", @temp), "\tNA\n";
			}
		}
	}
}
close (OUT);

#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
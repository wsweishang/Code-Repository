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
open (INTARGETGOTERM, "<D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/selected_gene_manhattan_distribution/target_go_term.txt") or die "$!";
open (INGOENRICHMENT, "<D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/selected_gene_manhattan_distribution/Table.5_WZ_vs_TJ_reseq_50kb_2kb_top005_gene_enrichment.txt") or die "$!";
open (INOVERLAP, "<D:/research work/Grass_carp/已有的整理好的图表和草稿_v2/selected_gene_manhattan_distribution/WZ_vs_TJ_reseq_50kb_2kb_top005_gene.overlap") or die "$!";

my %target_go_term = ();
while (<INTARGETGOTERM>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	$target_go_term{$data[0]} = 1;
}
close (INTARGETGOTERM);

my %target_gene_id = ();
while (<INGOENRICHMENT>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	
	if ($target_go_term{$data[2]}) {
		my @gene_id = split (/\|/, $data[7]);
		map {$target_gene_id{$_} = 1} @gene_id;
	}
}
close (INGOENRICHMENT);

my %target_chr = ();
while (<INOVERLAP>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	next unless ($data[2] eq "gene");
	$data[8] =~ /.*Name=([0-9a-zA-Z_]+).*/;
	my $gene_id = $1;
	if ($target_gene_id{$gene_id}) {
		$target_chr{$data[0]}{$gene_id} = 1;
#		print "$data[0]\t$data[3]\t$data[4]\t$gene_id\n";
	}
}
close (INOVERLAP);
my @all_chr = qw/LG01 LG02 LG03 LG04 LG05 LG06 LG07 LG08 LG09 LG10 LG11 LG12 LG13 LG14 LG15 LG16 LG17 LG18 LG19 LG20 LG21 LG22 LG23 LG24/;

#foreach my $chr (sort {$a cmp $b} keys %target_chr) {
#	foreach my $gene_id (sort {$a cmp $b} keys %{$target_chr{$chr}}) {
#		print "$chr\t$gene_id\n";
#		print "$chr\t", ;
#	}
#}

foreach my $chr (@all_chr) {
	if ($target_chr{$chr}) {
		print "$chr\t", scalar keys %{$target_chr{$chr}}, "\n";
	} else {
		print "$chr\t0\n";
	}
}

#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
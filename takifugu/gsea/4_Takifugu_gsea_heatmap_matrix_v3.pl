#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (PATHLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gsea_heatmap_pathlist.txt") or die "$!";
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/heatmap";
####################################################################################################
while (<PATHLIST>) {
	chomp (my $pathlist = $_);
	next if ($pathlist =~ /^#.*/);
	my @pathlist = split (/\t/, $pathlist);	
	my $output_path = $output_dir . "/" . $pathlist[0] . ".txt";
	my (%gct_gene_fpkm) = ();
	
	open (OUT, ">$output_path") or die "$!";
	open (INGCT, "<$pathlist[1]") or die "$!";
	while (<INGCT>) {
		chomp (my $gct = $_);
		my @gct = split (/\t/, $gct);
		if ($. <= 3) {
			if ($. == 3) {
				splice (@gct, 0, 2);
				my @header = map {substr ($gct[($_ * 3)], 0, -2)} 0..((scalar @gct / 3) - 1);
				print OUT "Name\t", join ("\t", @header), "\n";
			}
			next;
		}
		my ($gene_name, $description) = splice (@gct, 0, 2);
		my @fpkm = map {($gct[($_ * 3)] + $gct[($_ * 3) + 1] + $gct[($_ * 3) + 2]) / 3} 0..((scalar @gct / 3) - 1);
		map {push (@{$gct_gene_fpkm{$gene_name}}, $_)} @fpkm;
	}
	close (INGCT);
	
	open (INTSV, "<$pathlist[2]") or die "$!";
	while (<INTSV>) {
		chomp (my $tsv = $_);
		next if ($tsv =~ /^NAME.*/);
		my @tsv = split (/\t/, $tsv);
		if ($tsv[6] eq "Yes") {
			if (exists $gct_gene_fpkm{$tsv[1]}) {
				my @gene_fpkm = @{$gct_gene_fpkm{$tsv[1]}};
				my @sort_fpkm = sort {$a <=> $b} @gene_fpkm;
				my $min = $sort_fpkm[0];
				my $max = $sort_fpkm[-1];
				my $scale = ($max - $min) / 9;
				my @scale = map {(int (($_ - $min) / $scale)) + 1} @gene_fpkm;
				print OUT "$tsv[1]\t", join ("\t", @scale), "\n";
			} else {
				print STDERR "$tsv[1] not exist\n";
			}
		}
	}
	close (OUT);
	close (INTSV);
}
close (PATHLIST);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
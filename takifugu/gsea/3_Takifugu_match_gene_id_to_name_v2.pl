#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (GENELIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gene_id_comparison_table_v2.txt") or die "$!";
open (GMTLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gmt_pathlist.txt") or die "$!";
open (GMTOUT, ">D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_target_pathway_geneset.gmt") or die "$!";
open (NOTFOUND, ">D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_target_pathway_notfound.txt") or die "$!";
####################################################################################################
my (%genelist) = ();
while (<GENELIST>) {
	chomp (my $genelist = $_);
	next if ($genelist =~ /^#.*/);
	my @genelist = split (/\t/, $genelist);
	$genelist{$genelist[4]} = $genelist[5];
}
close (GENELIST);


while (<GMTLIST>) {
	chomp (my $gmtlist = $_);
	next if ($gmtlist =~ /^#.*/);
	my @gmtlist = split (/\t/, $gmtlist);
	
	my (%mark) = ();
	
	print GMTOUT "$gmtlist[0]\t> $gmtlist[1]";
	open (GENESET, "<$gmtlist[2]") or die "$!";
	while (<GENESET>) {
		chomp (my $geneset = $_);
		next if ($geneset =~ /^HALLMARK.*/);
		next if ($geneset =~ /^>.*/);
		next if ($geneset =~ /^#.*/);
		my @geneset = split (/\t/, $geneset);
		my $target_gene_name = $geneset[0];
		$mark{$geneset[0]} = 1;
		$target_gene_name =~ s/^([a-zA-Z_]+[0-9]{0,1}[a-zA-Z0-9]{0,1}).*/$1/;
		foreach my $gene_id (sort {$a cmp $b} keys %genelist) {
#			if ($genelist{$gene_id} =~ /^$target_gene_name(?![0-9])/i) {
			if ($genelist{$gene_id} =~ /^$target_gene_name/i) {
#				print GMTOUT "\t${gene_id}_$genelist{$gene_id}_$target_gene_name";
				print GMTOUT "\t$gene_id";
				$mark{$geneset[0]} = 2;
			}
		}
	}
	print GMTOUT "\n";
	close (GENESET);
	
	
	print NOTFOUND "$gmtlist[0]\t$gmtlist[1]\t";
	foreach my $gene_name (sort {$a cmp $b} keys %mark) {
		print NOTFOUND "$gene_name " if ($mark{$gene_name} == 1);
	}
	print NOTFOUND "\n";
	
}
close (GMTLIST);
close (GMTOUT);
close (NOTFOUND);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
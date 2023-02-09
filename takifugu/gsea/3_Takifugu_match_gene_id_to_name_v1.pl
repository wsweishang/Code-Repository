#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (GENELIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gene_id_comparison_table_v1.txt") or die "$!";
open (GENESET, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/gmt/KEGG_APOPTOSIS_geneset.txt") or die "$!";
open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/gmt/Takifugu_rubripes_geneset_kegg_apoptosis.gmt") or die "$!";
####################################################################################################
my (%genelist) = ();
while (<GENELIST>) {
	chomp (my $genelist = $_);
	next if ($genelist =~ /^#.*/);
	my @genelist = split (/\t/, $genelist);
	$genelist{$genelist[4]} = $genelist[5];
}
close (GENELIST);

print OUT "KEGG_PPAR_SIGNALING_PATHWAY\t";
print OUT "> Genes mediating programmed cell death (apoptosis) by activation of caspases.";

my (%mark) = ();
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
		if ($genelist{$gene_id} =~ /^$target_gene_name/i) {
#			print OUT "$gene_id\t$genelist{$gene_id}\t$target_gene_name\n";
			print OUT "\t$gene_id";
			$mark{$geneset[0]} = 2;
		}
	}
}
print OUT "\n";
close (GENESET);
close (OUT);

foreach my $gene_name (sort {$a cmp $b} keys %mark) {
	print STDERR "$gene_name not found\n" if ($mark{$gene_name} == 1);
}
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
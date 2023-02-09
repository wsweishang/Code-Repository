#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (GTF, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes.fTakRub1.2.102.gtf") or die "$!";
open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gene_id_comparison_table_v2.txt") or die "$!";
#####################################################################################################
my (%gene_id) = ();
while (<GTF>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	if ($data[2] eq "gene") {
		$data[8] =~ /.*(gene_name).*/;
		if ($1) {
			(my $gene_id = $data[8]) =~ s/.*gene_id "([^"]+)".*/$1/;
			(my $gene_name = $data[8]) =~ s/.*gene_name "([^"]+)".*/$1/;
			if ($gene_id{$gene_id}) {
				print STDERR "$gene_id\n";
			} else {
				print OUT "$data[0]\t$data[3]\t$data[4]\t$data[2]\t$gene_id\t$gene_name\n";
			}
		}
	}
}
close (GTF);
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
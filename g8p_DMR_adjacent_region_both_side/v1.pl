#!/usr/bin/perl

use strict;
use warnings;

open (INDMR, "<D:/1/domestic_vs_foreign_DMR_LGs_delta02.txt") or die "$!";
open (INGFF, "<D:/1/C_idella_female_genemodels.v1.gmap_changedposition_LG_v3.gff") or die "$!";
open (OUT, ">D:/1/domestic_vs_foreign_5k_out.txt") or die "$!";
my $scale = 5000;

my %gff_data = ();
while (<INGFF>) {
	chomp (my $gff_data = $_);
	next if ($gff_data =~ /^#.*/);
	my @gff_data = split (/\t/, $gff_data);
	if ($gff_data[2] eq "gene") {
		my @attributes = split (/=/, $gff_data[8]);
		$gff_data{$gff_data[0]}{$gff_data[3]}{$gff_data[4]} = $attributes[-1];
	}
}
close (INGFF);

print OUT "#chr\tstart\tend\tlength\tnCG\tmeanMethy1\tmeanMethy2\tdiff.Methy\tareaStat\tgene name\n";
while (<INDMR>) {
	chomp (my $dmr_data = $_);
	next if ($dmr_data =~ /^chr.*/);
	my @dmr_data = split (/\t/, $dmr_data);
	my $dmr_start = $dmr_data[1] - $scale;
	my $dmr_end = $dmr_data[2] + $scale;
	foreach my $gene_start (sort {$a <=> $b} keys %{$gff_data{$dmr_data[0]}}) {
		foreach my $gene_end (sort {$a <=> $b} keys %{$gff_data{$dmr_data[0]}{$gene_start}}) {
			my $left = $dmr_start - $gene_end;
			my $right = $dmr_end - $gene_start;
			if ($left <= 0 and $right >= 0) {
				print OUT "$dmr_data\t$gff_data{$dmr_data[0]}{$gene_start}{$gene_end}\n";
			}
		}
	}
}
close (INDMR);
close (OUT);




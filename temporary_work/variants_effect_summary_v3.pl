#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;

open (PATH, "<$ARGV[0]") or die "$!";
open (VCF, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";

my (@order, %ortholog, %gene) = ();
while (<PATH>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my @txt = split (/\t/, $txt);
	push (@order, $txt[0]);
	open (GENE, "<$txt[2]") or die "$!";
	while (<GENE>) {
		chomp (my $gene = $_);
		next if ($gene =~ /^#.*/);
		my @gene = split (/\t/, $gene);
		$gene{$gene[0]}{"k_number"} = $gene[1];
		$gene{$gene[0]}{$txt[0]} = 1;
	}
	close (GENE);
}
close (PATH);

my (@pop, %pop) = ();
while (<DATA>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	$pop{$data[0]} = $data[1];
	push (@pop, $data[1]) unless (exists $pop{$data[1]});
	$pop{$data[1]} = 1;
}
close (DATA);

my ($num, @header, %vcf) = ();
while (<VCF>) {
	chomp (my $vcf = $_);
	next if ($vcf =~ /^##.*/);
	my @vcf = split (/\t/, $vcf);
	if ($vcf =~ /^#.*/) {
		@header = @vcf;
		next;
	}
	my @genotype = split (/,/, $vcf[4]);
	unshift (@genotype, $vcf[3]);
	my ($count, %ratio) = ();
	for (my $p = 9; $p <= $#header; $p++) {
		$vcf[$p] =~ /^([\d\.])[\/\|]([\d\.]):.*/;
		if ($1 ne ".") {
			$ratio{$genotype[$1]}{$pop{$header[$p]}}++;
			$count++;
		}
		if ($2 ne ".") {
			$ratio{$genotype[$2]}{$pop{$header[$p]}}++;
			$count++;
		}
	}
	my @ann = split (/,/, (split (/;/, $vcf[7]))[-1]);
	foreach my $ann (@ann) {
		my @tmp = split (/\|/, $ann);
		my $allele = substr ($tmp[0], -1);
		my @effect = split (/&/, $tmp[1]);
		foreach my $effect (@effect) {
			$num++;
			$vcf{$num}{"ref"} = $vcf[3];
			$vcf{$num}{"alt"} = $allele;
			$vcf{$num}{"effect"} = $effect;
			$vcf{$num}{"impact"} = $tmp[2];
			$vcf{$num}{"gene_name"} = $tmp[3];
			$vcf{$num}{"position"} = "$vcf[0]\t$vcf[1]";
			foreach my $pop (@pop) {
				if (exists $ratio{$allele}{$pop}) {
					$vcf{$num}{$pop} = "$ratio{$allele}{$pop} ($count)";
				} else {
					$vcf{$num}{$pop} = "NA";
				}
			}
		}
	}
}

foreach my $q (sort {$a <=> $b} keys %vcf) {
	next unless (exists $gene{$vcf{$q}{'gene_name'}});
	print OUT "$vcf{$q}{'gene_name'}\t$vcf{$q}{'position'}\t$vcf{$q}{'ref'}\t$vcf{$q}{'alt'}\t$vcf{$q}{'effect'}\t$vcf{$q}{'impact'}";
	foreach my $pop (@pop) {
		print OUT "\t$vcf{$q}{$pop}";
	}
	print OUT "\t$gene{$vcf{$q}{'gene_name'}}{'k_number'}";
	foreach my $order (@order) {
		if (exists $gene{$vcf{$q}{'gene_name'}}{$order}) {
			print OUT "\t$order";
		} else {
			print OUT "\t";
		}
	}
	print OUT "\n";
}
close (OUT);

printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;

__DATA__
C_idella_01_IN02	IN
C_idella_02_IN03	IN
C_idella_03_IN04	IN
C_idella_04_IN05	IN
C_idella_05_IN06	IN
C_idella_06_IN07	IN
C_idella_07_IN08	IN
C_idella_08_IN09	IN
C_idella_09_TJ05	TJ
C_idella_10_TJ08	TJ
C_idella_11_WZ02	WZ
C_idella_12_WZ04	WZ
C_idella_13_WZ06	WZ
C_idella_14_WZ07	WZ
C_idella_15_WZ08	WZ
C_idella_16_IN11	IN
C_idella_17_IN12	IN
C_idella_18_IN15	IN
C_idella_19_IN19	IN
C_idella_20_TJ11	TJ
C_idella_21_TJ15	TJ
C_idella_22_TJ18	TJ
C_idella_23_TJ23	TJ
C_idella_24_TJ41	TJ
C_idella_25_TJ46	TJ
C_idella_26_TJ48	TJ
C_idella_27_TJ49	TJ
C_idella_28_TJ51	TJ
C_idella_29_TJ53	TJ
C_idella_30_WZ11	WZ
C_idella_31_WZ13	WZ
C_idella_32_WZ14	WZ
C_idella_33_WZ25	WZ
C_idella_34_WZ27	WZ
C_idella_35_WZ30	WZ
C_idella_36_WZ32	WZ
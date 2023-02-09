#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
my $input_path = "D:/research work/WGCNA/BTBrainTPM/phenotype_weight_module_cyan_gene_seq_pep.fa";
my $split_num = 20;
####################################################################################################
$input_path =~ /(.*\/)([^\/]+)\.([fasta|fa]+)/;
my $output_path = $1;
my $output_name = $2;
my $output_file = $3;
my ($gene_num, %fasta) = ();
#print "$output_path\n$output_name\n$output_file\n";
open (FASTA, "<$input_path") or die "$!";
while (<FASTA>) {
	chomp (my $fasta = $_);
	if ($fasta =~ /^>(.*)/) {
		$gene_num++;
		$fasta{$gene_num}{"gene_id"} = $1;
	} else {
		$fasta{$gene_num}{"sequence"} .= $fasta;
	}
}
close (FASTA);
my $handle = 0;
foreach my $num (sort {$a <=> $b} keys %fasta) {
	my $i = (int (($num - 1) / $split_num)) + 1;
	if ($handle != $i) {
		my $gh = ((length $i) == 1)? "0$i": $i;
		open (OUT, ">${output_path}${output_name}_${gh}.${output_file}") or die "$!";
		$handle = $i
	}
	print OUT ">$fasta{$num}{'gene_id'}\n";
	print OUT "$fasta{$num}{'sequence'}\n";
}
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
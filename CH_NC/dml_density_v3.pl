#!/usr/bin/perl

use strict;
use warnings;

open (INFASTA,"<E:/final_corrected_genome_newLG.fasta") or die "$!";
open (INDML,"<E:/newLG_CH_DML_skin_vs_heart_allLG_d02_p001.txt") or die "$!";
open (OUT,">E:/dml_density_matrix_v1.txt") or die "$!";
my $pace = 2000;

my %fasta_cg_pos = ();
my $max_length = 0;
my $ID = ();
while (<INFASTA>) {
	chomp (my $fasta_data = $_);
	if ($fasta_data =~ /^>(.*)/) {
		$ID = $1;
		print "$ID\n";
	} else {
		my @sequence = split (//,$fasta_data);
		my $q = 1;
		foreach my $site (@sequence) {
			push (@{$fasta_cg_pos{$ID}}, $q) if ($site eq "C" or $site eq "G");
			$q++;
		}
		my $length = length $fasta_data;
		$max_length = $length if ($length >= $max_length);
	}
}
close (INFASTA);

#my %csv_dml_pos = ();
#my @dml_files_path = glob "E:/";
#foreach my $dml_file_path (@dml_files_path) {
#	open (INDML,"<$dml_file_path") or die "$!";
#	while (<INDML>) {
#		chomp (my $dml_data = $_);
#		next if ($dml_data =~ /^chr.*/);
#		my @dml_data = split (/\t/,$dml_data);
#		push (@{$csv_dml_pos{$dml_data[0]}}, $dml_data[1]);
#	}
#}
#close (INDML);

my %csv_dml_pos = ();
while (<INDML>) {
	chomp (my $dml_data = $_);
	next if ($dml_data =~ /^chr.*/);
	my @dml_data = split (/\t/,$dml_data);
	push (@{$csv_dml_pos{$dml_data[0]}}, $dml_data[1]);
}
close (INDML);

my $m = 0;
my $max = 0;
my $max_i = int ($max_length - 1)/$pace;
foreach my $chr_ID (keys %fasta_cg_pos) {
	my @cg = ();
	my @dml = ();
	foreach my $cg_pos_cluster (@{$fasta_cg_pos{$chr_ID}}) {
		my $p = int ($cg_pos_cluster - 1)/$pace;
		$cg[$p] += 1;
	}
	foreach my $dml_pos_cluster (@{$csv_dml_pos{$chr_ID}}) {
		my $d = int ($dml_pos_cluster - 1)/$pace;
		$dml[$d] += 1;
	}
	print OUT "$chr_ID\t";
	for (my $i = 0 ; $i <= $max_i ; $i++){
		my $result = ();
		if ($cg[$i]) {
			if ($dml[$i]) {
				$result = $dml[$i]/$cg[$i];
			} else {
				$result = 0;
			}
		} else {
			$result = -1;
		}
		$max = $result if ($result >= $max);
		print OUT "$result\t";
		$m++;
	}
	print OUT "\n";
	print "$chr_ID\t$m\t$max\n";
}
close (OUT);


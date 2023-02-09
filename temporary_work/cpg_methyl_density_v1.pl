#!usr/bin/perl

use strict;
use warnings;

open (INFASTA, "<$ARGV[0]") or die "$!";
open (INCOV, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";
my $scale = $ARGV[3];

#my %fasta_data = ();
my %fasta_len = ();
my $id = ();
while (<INFASTA>) {
	chomp (my $fasta_data = $_);
	if ($fasta_data =~ /^>(.*)/) {
		$id = $1;
	} else {
		my $length = length $fasta_data;
		$fasta_len{$id} += $length;
#		$fasta_data{$id} .= $fasta_data;
	}
}
close (INFASTA);

my %cov_data = ();
while (<INCOV>) {
	chomp (my $cov_data = $_);
	my @cov_data = split (/\t/, $cov_data);
	my $i = int (($cov_data[1] - 1) / $scale);
	$cov_data{$cov_data[0]}{$i}{"methyl"} += $cov_data[4];
	$cov_data{$cov_data[0]}{$i}{"unmethyl"} += $cov_data[5];
}
close (INCOV);

print OUT "#chr\tstart\tend\tmethyl_rate\n";
foreach my $chr (sort keys %cov_data) {
	foreach my $i (sort {$a <=> $b} keys %{$cov_data{$chr}}) {
		my $start = $i * $scale + 1;
		my $end = ($i + 1) * $scale;
		$end = ($end >= $fasta_len{$chr}) ? $fasta_len{$chr} : $end;
		my $methyl_rate = $cov_data{$chr}{$i}{"methyl"} / ($cov_data{$chr}{$i}{"methyl"} + $cov_data{$chr}{$i}{"unmethyl"});
		print OUT "$chr\t$start\t$end\t$methyl_rate\n";
	}
}
close (OUT);








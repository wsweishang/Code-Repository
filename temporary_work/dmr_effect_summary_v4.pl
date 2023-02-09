#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;

open (TXT, "<$ARGV[0]") or die "$!";
open (OUT, ">$ARGV[1]") or die "$!";

my (@file_name, %gene, %overlap) = ();
while (<TXT>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my ($file_name, $file_path) = (split (/\t/, $txt))[0..1];
	push (@file_name, $file_name);
	open (OVERLAP, "<$file_path") or die "$!";
	while (<OVERLAP>) {
		chomp (my $overlap = $_) or die "$!";
		next if ($overlap =~ /^#.*/);
		my @overlap = split (/\t/, $overlap);
		$gene{$overlap[0]} = $overlap[3];
		push (@{$overlap{$overlap[0]}{$file_name}{"overlap_length"}}, $overlap[1]);
		push (@{$overlap{$overlap[0]}{$file_name}{"overlap_exon_info"}}, $overlap[2]);
		push (@{$overlap{$overlap[0]}{$file_name}{"dmr_info"}}, $overlap[4]);
	}
	close (OVERLAP);
}
close (TXT);

print OUT "#gene_id\tgene_info\t";
print OUT join ("_overlap_length\t", @file_name), "_overlap_length\t";
print OUT join ("_overlap_exon\t", @file_name), "_overlap_exon\t";
print OUT join ("_dmr_info\t", @file_name), "_dmr_info\n";
foreach my $gene_id (sort {$a cmp $b} keys %overlap) {
	print OUT "$gene_id\t$gene{$gene_id}";
	foreach my $file_name (@file_name) {
		if ($overlap{$gene_id}{$file_name}{"overlap_length"}) {
			print OUT "\t", join ("|", @{$overlap{$gene_id}{$file_name}{"overlap_length"}});
		} else {
			print OUT "\t0";
		}
	}
	foreach my $file_name (@file_name) {
		if ($overlap{$gene_id}{$file_name}{"overlap_exon_info"}) {
			print OUT "\t", join ("|", @{$overlap{$gene_id}{$file_name}{"overlap_exon_info"}});
		} else {
			print OUT "\t0";
		}
	}
	foreach my $file_name (@file_name) {
		if ($overlap{$gene_id}{$file_name}{"dmr_info"}) {
			print OUT "\t", join ("|", @{$overlap{$gene_id}{$file_name}{"dmr_info"}});
		} else {
			print OUT "\t0";
		}
	}
	print OUT "\n";
}
close (OUT);

printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
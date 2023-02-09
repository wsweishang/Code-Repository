#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;

open (DMR, "<$ARGV[0]")  or die "$!";
open (GFF, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";


my ($i, %dmr) = ();
while (<DMR>) {
	chomp (my $dmr = $_);
	next if ($dmr =~ /^#.*/);
	$i++;
	my @dmr = split (/\t/, $dmr);
	$dmr{$i}{"chr"} = $dmr[0];
	$dmr{$i}{"start"} = $dmr[1] - 1000;
	$dmr{$i}{"end"} = $dmr[2] + 1000;
	$dmr{$i}{"content"} = $dmr;
}
close (DMR);

my (%gff, %overlap) = ();
while (<GFF>) {
	chomp (my $gff = $_);
	next if ($gff =~ /^#.*/);
	my @gff = split (/\t/, $gff);
	if ($gff[2] eq "gene") {
		my ($gene_start, $gene_end, $upstream_start, $upstream_end) = ();
		if ($gff[6] eq "+") {
			$gene_start = $gff[3] - 1000;
			$gene_end = $gff[4];
			$upstream_start = $gene_start;
			$upstream_end = $gff[3] - 1;
		} elsif ($gff[6] eq "-") {
			$gene_start = $gff[3];
			$gene_end = $gff[4] + 1000;
			$upstream_start = $gff[3] + 1;
			$upstream_end = $gene_end;
		}
		$gff[8] =~ /.*Name=([^;]+).*/;
		my $gene_id = $1;
		foreach my $num (sort {$a <=> $b} keys %dmr) {
			next if ($dmr{$num}{"chr"} ne $gff[0]);
			my @gene_overlap_result = &OVERLAP ($dmr{$num}{"start"}, $dmr{$num}{"end"}, $gene_start, $gene_end);
			if ($gene_overlap_result[0]) {
				push (@{$overlap{$gene_id}{$num}}, $gene_overlap_result[1]);
			} else {
				push (@{$overlap{$gene_id}{$num}}, 0);
			}
			my @upstream_overlap_result = &OVERLAP ($dmr{$num}{"start"}, $dmr{$num}{"end"}, $upstream_start, $upstream_end);
			if ($upstream_overlap_result[0]) {
				push (@{$overlap{$gene_id}{$num}}, $upstream_overlap_result[1] / 1000);
			} else {
				push (@{$overlap{$gene_id}{$num}}, 0);
			}
		}
		$gff{$gene_id}{"chr"} = $gff[0];
		$gff{$gene_id}{"start"} = $gff[3];
		$gff{$gene_id}{"end"} = $gff[4];
		$gff{$gene_id}{"orientation"} = $gff[6];
		next;
	}
	if ($gff[2] eq "exon") {
		my ($exon_start, $exon_end) = @gff[3..4];
		$gff[8] =~ /.*exon([^;]+).*Name=([^;]+).*/;
		my ($exon_num, $gene_id) = ($1, $2);
		foreach my $num (sort {$a <=> $b} keys %dmr) {
			next if ($dmr{$num}{"chr"} ne $gff[0]);
			my @exon_overlap_result = &OVERLAP ($dmr{$num}{"start"}, $dmr{$num}{"end"}, $exon_start, $exon_end);
			if ($exon_overlap_result[0]) {
				my $length = $exon_end - $exon_start + 1;
				push (@{$overlap{$gene_id}{$num}}, $exon_overlap_result[1] / $length);
			} else {
				push (@{$overlap{$gene_id}{$num}}, 0);
			}
		}
		next;
	}
}
close (GFF);

foreach my $gene_id (sort {$a cmp $b} keys %overlap) {
	print OUT "$gene_id\t$gff{$gene_id}{'chr'}\t$gff{$gene_id}{'start'}\t$gff{$gene_id}{'end'}\t$gff{$gene_id}{'orientation'}\t";
	foreach my $num (sort {$a <=> $b} keys %{$overlap{$gene_id}}) {
		my @overlap = @{$overlap{$gene_id}{$num}};
		my $overlap = shift @overlap;
		print OUT "$overlap\t", join ("..", @overlap), "\t$dmr{$num}{'content'}\n" if ($overlap);
	}
}
close (OUT);

sub OVERLAP {
	my ($a_start, $a_end, $b_start, $b_end) = @_[0..3];
	my $length = ($a_end - $a_start) + ($b_end - $b_start);
	my $range = abs ($a_start - $b_start) + abs ($a_end - $b_end);
	my $overlap = ($length - $range) / 2;
	if ($overlap >= 0) {
		return (1, $overlap + 1);
	} else {
		return (0, abs ($overlap));
	}
}

printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
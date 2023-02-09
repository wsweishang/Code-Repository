#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;

open (TXT, "<$ARGV[1]") or die "$!";
open (GFF, "<$ARGV[0]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";


my (@file_name, %dmr) = ();
while (<TXT>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my ($file_name, $file_path) = (split (/\t/, $txt))[0..1];
	my $i = ();
	push (@file_name, $file_name);
	open (DMR, "<$file_path")  or die "$!";
	while (<DMR>) {
		chomp (my $dmr = $_);
		next if ($dmr =~ /^#.*/);
		$i++;
		my @dmr = split (/\t/, $dmr);
		$dmr{$file_name}{$i}{"chr"} = $dmr[0];
		$dmr{$file_name}{$i}{"start"} = $dmr[1] - 1000;
		$dmr{$file_name}{$i}{"end"} = $dmr[2] + 1000;
		$dmr{$file_name}{$i}{"length"} = $dmr[3];
		$dmr{$file_name}{$i}{"nCG"} = $dmr[4];
		$dmr{$file_name}{$i}{"meanMethy1"} = $dmr[5];
		$dmr{$file_name}{$i}{"meanMethy2"} = $dmr[6];
		$dmr{$file_name}{$i}{"diff.Methy"} = $dmr[7];
		$dmr{$file_name}{$i}{"areaStat"} = $dmr[8];
	}
	close (DMR);
}
close (TXT);


my (%gff, %overlap) = ();
while (<GFF>) {
	chomp (my $gff = $_);
	next if ($gff =~ /^#.*/);
	my @gff = split (/\t/, $gff);
##############################################################################
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
		my $id = $1;
		foreach my $file_name (@file_name) {
			foreach my $num (sort {$a <=> $b} keys %{$dmr{$file_name}}) {
				next if ($dmr{$file_name}{$num}{"chr"} ne $gff[0]);
				my @gene_overlap_result = &OVERLAP ($dmr{$file_name}{$num}{"start"}, $dmr{$file_name}{$num}{"end"}, $gene_start, $gene_end);
				if ($gene_overlap_result[0]) {
					$overlap{$id}{$file_name}{$num}{"-1"} = $gene_overlap_result[1];
				} else {
					$overlap{$id}{$file_name}{$num}{"-1"} = 0;
				}
				my @upstream_overlap_result = &OVERLAP ($dmr{$file_name}{$num}{"start"}, $dmr{$file_name}{$num}{"end"}, $upstream_start, $upstream_end);
				if ($upstream_overlap_result[0]) {
					$overlap{$id}{$file_name}{$num}{"0"} = $upstream_overlap_result[1] / 1000;
				} else {
					$overlap{$id}{$file_name}{$num}{"0"} = 0;
				}
			}
		}
		
		$gff{$id}{"chr"} = $gff[0];
		$gff{$id}{"start"} = $gff[3];
		$gff{$id}{"end"} = $gff[4];
		$gff{$id}{"orientation"} = $gff[6];
		next;
	}
##############################################################################
	if ($gff[2] eq "exon") {
		my ($exon_start, $exon_end) = @gff[3..4];
		$gff[8] =~ /.*exon([^;]+).*Name=([^;]+).*/;
		my $exon_num = $1;
		my $id = $2;
		foreach my $file_name (@file_name) {
			foreach my $num (sort {$a <=> $b} keys %{$dmr{$file_name}}) {
				next if ($dmr{$file_name}{$num}{"chr"} ne $gff[0]);
				my @exon_overlap_result = &OVERLAP ($dmr{$file_name}{$num}{"start"}, $dmr{$file_name}{$num}{"end"}, $exon_start, $exon_end);
				if ($exon_overlap_result[0]) {
					my $length = $exon_end - $exon_start + 1;
					$overlap{$id}{$file_name}{$num}{$exon_num} = $exon_overlap_result[1] / $length;
				} else {
					$overlap{$id}{$file_name}{$num}{$exon_num} = 0;
				}
			}
		}
		next;
	}
}
close (GFF);

foreach my $gene_id (sort {$a cmp $b} keys %overlap) {
	print OUT "$gene_id\t";
	foreach my $file_name (@file_name) {
		foreach my $num (sort {$a <=> $b} keys %{$overlap{$gene_id}{$file_name}}) {
			foreach my $exon_num (sort {$a <=> $b} keys %{$overlap{$gene_id}{$file_name}{$num}}) {
				print OUT "($overlap{$gene_id}{$file_name}{$num}{$exon_num})";
			}
		}
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
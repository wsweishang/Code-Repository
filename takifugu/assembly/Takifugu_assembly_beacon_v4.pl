#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);

my $start_time = gettimeofday;
###########################################################################################################################
open (FNA, "<D:/research work/Takifugu/02.assembly/Takifugu_obscurus.fna") or die "$!";
open (TXT, "<D:/research work/Takifugu/02.assembly/synteny_gene_v2.txt") or die "$!";
open (GFF, "<D:/research work/Takifugu/02.assembly/Takifugu_obscurus.gff") or die "$!";
open (ORD, "<D:/research work/Takifugu/02.assembly/02_beacon.txt") or die "$!";
open (OUT, ">D:/research work/Takifugu/02.assembly/03_genome.fna") or die "$!";
###########################################################################################################################
my ($id, %fa, %txt, %gff) = ();
while (<FNA>) {
	chomp (my $fa = $_);
	if ($fa =~ /^>(.*)/) {
		$id = $1;
	} else {
		$fa{$id} .= $fa;
	}
}
close (FNA);

while (<TXT>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my @txt = split (/\t/, $txt);
	$txt{$txt[0]} = $txt[1];
	$txt{$txt[1]} = $txt[0];
}
close (TXT);

while (<GFF>) {
	chomp (my $gff = $_);
	next if ($gff !~ /^Fugu.*/);
	my @gff = split (/\t/, $gff);
	if ($gff[2] eq "gene") {
		$gff[8] =~ /.*Name=([^;]+).*/;
		my $gene_name = $1;
		if (exists $txt{$gene_name}) {
			my $middle = ($gff[3] + $gff[4]) / 2;
			$gff{$gff[0]}{$middle}{"gene_id"} = $gene_name;
			$gff{$gff[0]}{$middle}{"scaffold"} = $gff[0];
			$gff{$gff[0]}{$middle}{"start"} = $gff[3];
			$gff{$gff[0]}{$middle}{"end"} = $gff[4];
		}
	}
}
close (GFF);
###########################################################################################################################
my (%order, %region) = ();
foreach my $scaffold (keys %gff) {
	my $i = 1;
	foreach my $position (sort {$a <=> $b} keys %{$gff{$scaffold}}) {
		$order{$scaffold}{$i}{"gene_id"} = $gff{$scaffold}{$position}{"gene_id"};
		$order{$scaffold}{$i}{"start"} = $gff{$scaffold}{$position}{"start"} - 1;
		$order{$scaffold}{$i}{"end"} = $gff{$scaffold}{$position}{"end"} - 1;
		$i++;
	}
}

foreach my $scaffold (keys %order) {
	my $scaffold_length = (length $fa{$scaffold}) - 1;
	foreach my $num (sort {$a <=> $b} keys %{$order{$scaffold}}) {
		my $last_num = $num - 1;
		my $next_num = $num + 1;
		my $gene_id = $order{$scaffold}{$num}{"gene_id"};
		my $start = $order{$scaffold}{$num}{"start"};
		my $end = $order{$scaffold}{$num}{"end"};
		if (exists $order{$scaffold}{$next_num}{"start"}) {
			if (exists $order{$scaffold}{$last_num}{"end"}) {
				my $next_start = $order{$scaffold}{$next_num}{"start"};
				my $last_end = $order{$scaffold}{$last_num}{"end"};
				my $last_gap = $start - $last_end - 1;
				my $next_gap = $next_start - $end - 1;
				$last_gap = $last_gap - int($last_gap/ 2);
				$next_gap = int($next_gap/ 2);
				my $left_point = $start - $last_gap;
				my $right_point = $end + $next_gap;
				$region{$gene_id}{"left"} = $left_point;
				$region{$gene_id}{"right"} = $right_point;
			} else {
				my $next_start = $order{$scaffold}{$next_num}{"start"};
				my $next_gap = $next_start - $end - 1;
				$next_gap = int($next_gap/ 2);
				my $right_point = $end + $next_gap;
				$region{$gene_id}{"left"} = 0;
				$region{$gene_id}{"right"} = $right_point;
			}
		} else {
			if (exists $order{$scaffold}{$last_num}{"end"}) {
				my $last_end = $order{$scaffold}{$last_num}{"end"};
				my $last_gap = $start - $last_end - 1;
				$last_gap = $last_gap - int($last_gap/ 2);
				my $left_point = $start - $last_gap;
				$region{$gene_id}{"left"} = $left_point;
				$region{$gene_id}{"right"} = $scaffold_length;
			} else {
				$region{$gene_id}{"left"} = 0;
				$region{$gene_id}{"right"} = $scaffold_length;
			}
		}
	}
}
###########################################################################################################################
my $scaffold = 1;
my %genome = ();
while (<ORD>) {
	chomp (my $beacon = $_);
	next if ($beacon =~ /^#.*/);
	my @beacon = split (/\t/, $beacon);
	my $start = $region{$beacon[5]}{"left"};
	my $length = $region{$beacon[5]}{"right"} - $start + 1;
	my $sequence = ();
	if ($beacon[8] eq "+") {
		$sequence = substr($fa{$beacon[6]}, $start, $length);
	} else {
		$sequence = substr($fa{$beacon[6]}, $start, $length);
		$sequence = reverse $sequence;
		$sequence =~ tr/ATCGatcg/TAGCtagc/;
	}
	$genome{$beacon[0]} .= $sequence;
	$genome{$beacon[0]} .= "N" x300 if ($beacon[9] == 0);
}
close (ORD);

my $all_length = ();
foreach my $chr (sort {$a cmp $b} keys %genome) {
	my $sequence = substr($genome{$chr}, -300) = "";
	my $length = (length $sequence)/ 1000000;
	print "$chr\t$length\tmb\n";
	$all_length += $length;
	print OUT ">$chr\n";
	print OUT "$sequence\n";
}
close (OUT);
print "WholeGenome\t$all_length\tmb\n";

printf "[total run time: %f s]\n", gettimeofday - $start_time;
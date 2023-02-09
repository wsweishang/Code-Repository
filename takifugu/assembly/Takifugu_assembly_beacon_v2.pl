#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);

my $start_time = gettimeofday;
###########################################################################################################################
open (TXT, "<D:/research work/Takifugu/02.assembly/synteny_gene_v2.txt") or die "$!";
open (GTF, "<D:/research work/Takifugu/02.assembly/Takifugu_rubripes.gtf") or die "$!";
open (GFF, "<D:/research work/Takifugu/02.assembly/Takifugu_obscurus.gff") or die "$!";
open (OUT, ">D:/research work/Takifugu/02.assembly/allmaps_input.txt") or die "$!";
###########################################################################################################################
my (%txt, %gtf, %gff) = ();
while (<TXT>) {
	chomp (my $txt = $_);
	next if ($txt =~ /^#.*/);
	my @txt = split (/\t/, $txt);
	$txt{$txt[0]} = $txt[1];
	$txt{$txt[1]} = $txt[0];
}
close (TXT);

while (<GTF>) {
	chomp (my $gtf = $_);
	next if ($gtf =~ /^#.*/);
	my @gtf = split (/\t/, $gtf);
	if ($gtf[2] eq "CDS") {
		$gtf[8] =~ /.*gene_id\s"([^;]+)".*gene_version\s"([^;]+)".*protein_id\s"([^;]+)".*protein_version\s"([^;]+)"/;
		my ($gene_id, $gene_version, $protein_id, $protein_version) = ($1, $2, $3, $4);
		if (exists $txt{"$protein_id.$protein_version"}) {
			$gtf{"$protein_id.$protein_version"}{"chr"} = $gtf[0];
			$gtf{"$protein_id.$protein_version"}{"gene_id"} = $gene_id;
			$gtf{"$protein_id.$protein_version"}{"direction"} = $gtf[6];
			$gtf{"$protein_id.$protein_version"}{"gene_version"} = $gene_version;
			if ($gtf[6] eq "+") {
				push (@{$gtf{"$protein_id.$protein_version"}{"position"}}, $gtf[3]);
				push (@{$gtf{"$protein_id.$protein_version"}{"position"}}, $gtf[4]);
			} elsif ($gtf[6] eq "-") {
				push (@{$gtf{"$protein_id.$protein_version"}{"position"}}, $gtf[4]);
				push (@{$gtf{"$protein_id.$protein_version"}{"position"}}, $gtf[3]);
			}
		}
	}
}
close (GTF);

while (<GFF>) {
	chomp (my $gff = $_);
	next if ($gff !~ /^Fugu.*/);
	my @gff = split (/\t/, $gff);
	if ($gff[2] eq "gene") {
		$gff[8] =~ /.*Name=([^;]+).*/;
		my $gene_name = $1;
		if (exists $txt{$gene_name}) {
			my $middle = ($gff[3] + $gff[4]) / 2;
			$gff{$gff[0]}{$middle} = $gene_name;
		}
	}
}
close (GFF);
###########################################################################################################################
my (%reference, %order) = ();
foreach my $protein (keys %gtf) {
	my $chr = $gtf{$protein}{"chr"};
	my $start = @{$gtf{$protein}{"position"}}[0];
	my $end = @{$gtf{$protein}{"position"}}[-1];
	my $middle = ($start + $end) /2;
	$chr = (length $chr == 1)? "0$chr": $chr;
	$reference{$chr}{$middle}{"gene"} = $txt{$protein};
#	print "$chr\t$start\t$end\t$gtf{$protein}{\"direction\"}\t$protein\t$txt{$protein}\n" if ($protein eq "ENSTRUP00000004985.2");
	$reference{$chr}{$middle}{"content"} = "$chr\t$start\t$end\t$middle\t$gtf{$protein}{\"direction\"}\t$protein\t$txt{$protein}";
#	print "$chr\t$start\t$end\t$gtf{$protein}{\"direction\"}\t$protein\t$txt{$protein}\n" if ($middle == 371294);
}

foreach my $scaffold (keys %gff) {
	my $i = 1;
	foreach my $position (sort {$a <=> $b} keys %{$gff{$scaffold}}) {
		$order{$gff{$scaffold}{$position}} = "$scaffold\t$position\t$i";
#		print "$order{$gff{$scaffold}{$position}}\n" if ($gff{$scaffold}{$position} eq "Fuguv2-19115");
		$i++;
	}
}
###########################################################################################################################
foreach my $chr (sort {$a cmp $b} keys %reference) {
	foreach my $position (sort {$a <=> $b} keys %{$reference{$chr}}) {
		print OUT "$reference{$chr}{$position}{\"content\"}\t$order{$reference{$chr}{$position}{\"gene\"}}\n";
	}
}
close (OUT);
printf "[total run time: %f s]\n", gettimeofday - $start_time;



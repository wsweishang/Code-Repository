#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (TXT, "<$ARGV[0]") or die "$!";
open (PEP, "<$ARGV[1]") or die "$!";
open (GFF, "<$ARGV[2]") or die "$!";
open (VCF, "<$ARGV[3]") or die "$!";
open (OUT, ">$ARGV[4]") or die "$!";
####################################################################################################
my (%gene) = ();
while (<TXT>) {
	chomp (my $gene = $_);
	next if ($gene =~ /^#.*/);
	my $gene_id = (split (/\t/, $gene))[0];
	$gene{$gene_id} = 1;
}
close (TXT);
####################################################################################################
my (%gene_name) = ();
while (<PEP>) {
	chomp (my $fasta = $_);
	next if ($fasta =~ /^#.*/);
	if ($fasta =~ /^>.*/) {
		(my $gene_id = $fasta) =~ s/^>.*gene:(ENSTRUG\d+).*/$1/;
		(my $gene_symbol = $fasta) =~ s/^>.*gene_symbol:(\d+).*/$1/;
		(my $transcript_id = $fasta) =~ s/^>.*transcript:(ENSTRUT\d+).*/$1/;
		$gene_name{$gene_id} = $gene_symbol;
		$gene_name{$transcript_id} = $gene_symbol;
	}
}
close (PEP);
####################################################################################################
my (%gff) = ();
while (<GFF>) {
	chomp (my $gff = $_);
	next if ($gff =~ /^#.*/);
	my @gff = split (/\t/, $gff);
	if ($gff[2] eq "gene") {
		my $gene_id = ();
		if ($gff[8] =~ /gene_id=(ENSTRUG\d+)/) {
			$gene_id = $1;
		} else {
			next;
			print STDERR "$gff\n";
		}
		if ($gff[6] eq "+") {
			push (@{$gff{$gff[0]}{"start"}}, $gff[3] - 2000);
			push (@{$gff{$gff[0]}{"end"}}, $gff[3] - 1);
			push (@{$gff{$gff[0]}{"gene_id"}}, $gene_id);
        }
        if ($gff[6] eq "-") {
        	push (@{$gff{$gff[0]}{"start"}}, $gff[4] + 1);
			push (@{$gff{$gff[0]}{"end"}}, $gff[4] + 2000);
			push (@{$gff{$gff[0]}{"gene_id"}}, $gene_id);
        }
	}
}
close (GFF);
####################################################################################################
while (<VCF>) {
	chomp (my $vcf = $_);
	next if ($vcf =~ /^#.*/);
	my ($chr, $pos) = (split (/\t/, $vcf))[0..1];
	my @gene_id = @{$gff{$chr}{"gene_id"}};
	my @start = @{$gff{$chr}{"start"}};
	my @end = @{$gff{$chr}{"end"}};
	
	if (@start != @gene_id) {
		print STDERR "$chr\t$pos\n";
	} elsif (@end != @gene_id) {
		print STDERR "$chr\t$pos\n";
	} else {
		for (my $i = 0; $i <= $#gene_id; $i++) {
			next unless ($gene{$gene_id[$i]});
			my ($start, $end) = ($start[$i], $end[$i]);
			if ($start <= $pos && $pos <= $end) {
				print OUT "$vcf\n";
			}
		}
	}
}
close (VCF);
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
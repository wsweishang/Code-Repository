#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (INDR,"<G:/result/g8p_Dr-Gc_snp_tblastn_F.output_coverage_index") or die "$!";
open (INFASTA,"<G:/result/gc.fasta")or die "$!";
open (OUT1,">G:/first_blast_result.txt") or die "$!";
open (OUT2,">G:/need_second_blast_gc.fasta") or die "$!";

my %dr=();
foreach my $dr(<INDR>){
	chomp $dr;
	next unless ($dr=~/^EN/);
	my @dr=split (/\t/,$dr);
	$dr{$dr[1]}{$dr[2]}="$dr[5]";
}

my %fasta=();
my $ID=();
foreach my $fasta(<INFASTA>){
	chomp $fasta;
	if ($fasta=~/^>(.*)/){
		$ID=$1;
	}elsif ($fasta!~/^>.*/){
		$fasta{$ID}=$fasta;
	}
}

my %hash=();
foreach my $key1(keys %dr){
	my $max=0;
	my @maxkey=();
	my $i=0;
	foreach my $key2(sort {$dr{$key1}{$b} <=> $dr{$key1}{$a}}keys %{$dr{$key1}}){
		if ($dr{$key1}{$key2} >= $max){
			$max=$dr{$key1}{$key2};
			$maxkey[$i]=$key2;
			$i++;
		}
	}
	foreach my $fh(@maxkey){
		$hash{$fh}{$key1}=$max;
	}
	undef $max;
	undef @maxkey;
}

foreach my $k1(keys %hash){
	print OUT2 ">$k1\n";
	print OUT2 "$fasta{$k1}\n";
	foreach my $k2(keys %{$hash{$k1}}){
		print OUT1 "$k1 => $k2 => $hash{$k1}{$k2}\n";
	}
}

#say OUT2 Dumper (\%fasta);
#say OUT1 Dumper (\%hash);
close (INDR);
close (INFASTA);
close (OUT1);
close (OUT2);

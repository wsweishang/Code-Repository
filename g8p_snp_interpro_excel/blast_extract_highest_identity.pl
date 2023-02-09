#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (INDR,"<G:/result/g8p_Dr-Gc_snp_tblastn_F.output_coverage_index") or die "$!";
open (INGC,"<G:/g8p_Gc-Dr_2_snp_blastx.output_coverage_index") or die "$!";
open (OUT1,">G:/first_blast_result.txt") or die "$!";
open (OUT2,">G:/second_blast_result.txt") or die "$!";
open (OUT3,">G:/count.txt") or die "$!";

my %dr=();
foreach my $dr(<INDR>){
	chomp $dr;
	next unless ($dr=~/^EN/);
	my @dr=split (/\t/,$dr);
	$dr{$dr[1]}{$dr[2]}="$dr[5]";
}
my %gc=();
foreach my $gc(<INGC>){
	chomp $gc;
	next unless ($gc=~/^CI/);
	my @gc=split (/\t/,$gc);
	$gc{$gc[1]}{$gc[2]}="$gc[5]";
}
my %hash_dr=();
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
		$hash_dr{$fh}{$key1}=$max;
	}
	undef $max;
	undef @maxkey;
}
my %hash_gc=();
foreach my $key3(keys %gc){
	my $max=0;
	my @maxkey=();
	my $i=0;
	foreach my $key4(sort {$gc{$key3}{$b} <=> $gc{$key3}{$a}}keys %{$gc{$key3}}){
		if ($gc{$key3}{$key4} >= $max){
			$max=$gc{$key3}{$key4};
			$maxkey[$i]=$key4;
			$i++;
		}
	}
	foreach my $gh(@maxkey){
		$hash_gc{$key3}{$gh}=$max;
	}
	undef $max;
	undef @maxkey;
}

my %hash=();
foreach my $key_1(keys %hash_dr){
	foreach my $key_2(keys %{$hash_dr{$key_1}}){
		if (exists $hash_gc{$key_1}{$key_2}){
			$hash{$key_1}{$key_2}="$hash_dr{$key_1}{$key_2}\t$hash_gc{$key_1}{$key_2}";
		}
	}
}

my %blast=();
foreach my $k(keys %hash){
	my $left_max=0;
	my $right_max=0;
	my $maxlist=();
	my $i=0;
	foreach my $kk(keys %{$hash{$k}}){
		my @qq=split(/\t/,$hash{$k}{$kk});
		if ($qq[0] >= $left_max and $qq[1] >= $right_max){
			$left_max=$qq[0];
			$right_max=$qq[1];
			$maxlist=$kk;
		}
	}
	$blast{$k}{$maxlist}="$left_max\t$right_max";
}

foreach my $k(keys %blast){
	foreach my $kk(keys %{$blast{$k}}){
		print OUT3 "$k\t$kk\t$blast{$k}{$kk}\n";
	}
}
foreach my $k1(keys %hash_dr){
	foreach my $k2(keys %{$hash_dr{$k1}}){
		print OUT1 "$k1 => $k2 => $hash_dr{$k1}{$k2}\n";
		
	}
}
foreach my $k1(keys %hash_gc){
	foreach my $k2(keys %{$hash_gc{$k1}}){
		print OUT2 "$k1 => $k2 => $hash_gc{$k1}{$k2}\n";
	}
}
close (INDR);
close (INGC);
close (OUT1);
close (OUT2);
close (OUT3);

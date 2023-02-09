#!/usr/bin/perl

use strict;
use warnings;

open (INSNPVCF,"<$ARGV[0]") or die "$!";
open (ININDELVCF,"<$ARGV[1]") or die "$!";
open (INSCAFFOLDPOSLIST,"<$ARGV[2]") or die "$!";
open (OUT,"<$ARGV[8]") or die "$!";
my $snp_nbp_around_snp = $ARGV[3];
my $snp_nbp_around_indel = $ARGV[4];
my $snp_nbp_of_head_and_tail = $ARGV[5];
my $snp_min_depth = $ARGV[6];
my $AD_min_ratio = $ARGV[7];
#my $snp_nbp_around_indel = $ARGV[0];

my %indel_vcf_site = ();
while (<ININDELVCF>) {
	chomp (my $indel_vcf_data = $_);
	next if ($indel_vcf_data =~ /^#.*/);
	my @indel_vcf_data = split (/\t/,$indel_vcf_data);
	push (@{$indel_vcf_site{$indel_vcf_data[0]}}, $indel_vcf_data[1]);
}
close (ININDELVCF);

my %scaffold_list = ();
while (<INSCAFFOLDPOSLIST>) {
	chomp (my $scaffold_list_data = $_);
	next if ($scaffold_list_data =~ /^LG.*/);
	my @scaffold_list_data = split (/\t/,$scaffold_list_data);
	my $end = $scaffold_list_data[3] + $scaffold_list_data[2] - 1;
	push (@{$scaffold_list{$scaffold_list_data[0]}{"start"}}, $scaffold_list_data[3]);
	push (@{$scaffold_list{$scaffold_list_data[0]}{"end"}}, $end);
}
close (INSCAFFOLDPOSLIST);

my %snp_vcf_site = ();
my %snp_vcf_info = ();
my @LG_order = ();
my $LG_number = "LG00";
while (<INSNPVCF>) {
	chomp (my $snp_vcf_data = $_);
	next if ($snp_vcf_data =~ /^#.*/);
	my @snp_vcf_data = split (/\t/,$snp_vcf_data);
	push (@{$snp_vcf_site{$snp_vcf_data[0]}{"site"}}, $snp_vcf_data[1]);
	$snp_vcf_info{$snp_vcf_data[0]}{$snp_vcf_data[1]} = $snp_vcf_data;
	if ($snp_vcf_data[0] ne $LG_number) {
		push (@LG_order, $snp_vcf_data[0]);
		$snp_vcf_data[0] = $LG_number;
	}
}
close (INSNPVCF);
my @main_array = ();
my $start_snp = 0;
foreach my $LG_number (@LG_order) {
	foreach my $indel_vcf_site (@{$indel_vcf_site{$LG_number}}) {
		$main_array[$indel_vcf_site] = "indel";
	}
	foreach my $scaffold_start_site (@{$scaffold_list{$LG_number}{"start"}}) {
		$main_array[$scaffold_start_site] = "start";
	}
	foreach my $scaffold_end_site (@{$scaffold_list{$LG_number}{"end"}}) {
		$main_array[$scaffold_end_site] = "end";
	}
	foreach my $snp_vcf_site (@{$scaffold_list{$LG_number}{"end"}}) {
		$main_array[$snp_vcf_site] = "snp";
	}
	
	&MAIN ($start_snp);
	
	
	
	
	
}

sub MAIN {
	my $position = $_[0];
	my $next_valid_position = &NEXTVALIDPOS ($position);
	my $next_snp_position = &NEXTSNPPOS ($position);
	if ($position - $next_valid_position > 5) {
		
	}
	
	
	
	
}

sub NEXTVALIDPOS {
	my $position = $_[0] + 1;
	my $max = $#main_array;
	if ($main_array[$position]) {
		return $position;   #return next valid position
	} elsif ($position < $max) {
		&NEXTVALIDPOS ($position);
	} else {
		return undef;   #doesnt exist next valid position
	}
}

sub NEXTSNPPOS {
	my $position = $_[0] + 1;
	my $max = $#main_array;
	if ($main_array[$position] eq "snp") {
		return $position;   #return next valid position
	} elsif ($position < $max) {
		&NEXTSNPPOS ($position);
	} else {
		return undef;   #doesnt exist next valid position
	}
}







































close (OUT);
#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#(AX, TJ, YJ, WZ, ZJ) VS (NP, IN)

sub SUM{
	my @all=@_;
	$all[12] += $all[11];
	$all[13] += $all[12];
	$all[14] += $all[13];
	$all[16] += $all[14];
	$all[17] += $all[16];
	$all[18] += $all[17];
	return $all[18];
}

open (OUT,">G:/(AX, TJ, YJ, WZ, ZJ) VS (NP, IN).txt");
my %compared_data=();
my @population_compared_filenames=qw/NP_S1_snp_snpEff_genes.txt IN_S2_snp_snpEff_genes.txt/;
foreach my $population_compared_filename(@population_compared_filenames){
	open (INCOMPARED,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/${population_compared_filename}");
	my @population_compared_file=<INCOMPARED>;
	foreach my $population_compared_data(@population_compared_file){
		chomp $population_compared_data;
		next if ($population_compared_data=~/^#.*/);
		my @population_compared_content=split(/\t/,$population_compared_data);
		$compared_data{$population_compared_content[1]}{$population_compared_filename}=1;
	}	
}

my @population_compare_filenames=qw/AX_S4_snp_snpEff_genes.txt TJ_S3_snp_snpEff_genes.txt YJ_S2_snp_snpEff_genes.txt WZ_S1_snp_snpEff_genes.txt ZQ_S4_snp_snpEff_genes.txt/;
foreach my $population_compare_filename(@population_compare_filenames){
	open (INCOMPARE,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/${population_compare_filename}");
	my @population_compare_file=<INCOMPARE>;
	foreach my $population_compare_data(@population_compare_file){
		chomp $population_compare_data;
		next if ($population_compare_data=~/^#.*/);
		my @population_compare_content=split(/\t/,$population_compare_data);
		unless (exists $compared_data{$population_compare_content[1]}){
			my $result=&SUM(@population_compare_content);
			unless ($result==0){
				say OUT $population_compare_data;
			}
		}
	}
}
close (OUT);



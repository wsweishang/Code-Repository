#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (GENELIST, "<D:/research work/Takifugu/RNAseq/03.statistics/09.GSEA/Takifugu_rubripes_gene_id_comparison_table_v2.txt") or die "$!";
open (PATHLIST, "<D:/research work/Takifugu/RNAseq/03.statistics/04.Shared_gene/cluster_1/Takifugu_rubripes_venn_deg_share_pathlist.txt") or die "$!";
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/04.Shared_gene/cluster_1";
#####################################################################################################
my (%genelist) = ();
while (<GENELIST>) {
	chomp (my $genelist = $_);
	next if ($genelist =~ /^#.*/);
	my @genelist = split (/\t/, $genelist);
	next if ($genelist[5] =~ /^si:.*/);
	next if ($genelist[5] =~ /^zgc:.*/);
	next if ($genelist[5] =~ /^U4.*/);
	next if ($genelist[5] =~ /^Vault.*/);
	next if ($genelist[5] =~ /^5S_rRNA.*/);
	$genelist{$genelist[4]} = uc ($genelist[5]);
}
close (GENELIST);
#####################################################################################################
while (<PATHLIST>) {
	chomp (my $pathlist = $_);
	next if ($pathlist =~ /^#.*/);
	my @pathlist = split (/\t/, $pathlist);
	my $output_filename = splice (@pathlist, 0, 1);
	my $output_union_filepath = $output_dir . "/" . $output_filename . "_union.txt";
	my $output_intersection_filepath = $output_dir . "/" . $output_filename . "_intersection.txt";
	open (OUTUNION, ">$output_union_filepath") or die "$!";
	open (OUTINTERSECTION, ">$output_intersection_filepath") or die "$!";
	
	my (%union, %intersection) = ();
	foreach my $path (@pathlist) {
		my @input_deg_path = split (/\|/, $path);
		my $number = scalar @input_deg_path;
		my %temp = ();
		foreach my $input_deg_path (@input_deg_path) {
			open (INDEG, "<$input_deg_path") or die "$!";
			while (<INDEG>) {
				chomp (my $deg = $_);
				next if ($deg =~ /^test_id.*/);
				my @deg = split (/\t/, $deg);
				next unless ($genelist{$deg[0]});
				if ($deg[11] <= 0.05) {
					$union{$deg[0]} = 1;
					if ($deg[9] >= 0) {
						$temp{$deg[0]} += 1;
					} else {
						$temp{$deg[0]} -= 1;
					}
				}		
			}
			close (INDEG);
		}
		
		foreach my $temp (sort {$a cmp $b} keys %temp) {
			if (abs($temp{$temp}) == $number) {
				$intersection{$temp} = 1;
			}
			if ($temp{$temp} > $number) {
				print STDERR "$temp\n";
			}
		}
	}
	
	foreach my $union_gene (sort {$a cmp $b} keys %union) {
		print OUTUNION "$union_gene\t$genelist{$union_gene}\n";
	}
	close (OUTUNION);
	
	foreach my $intersection_gene (sort {$a cmp $b} keys %intersection) {
		print OUTINTERSECTION "$intersection_gene\t$genelist{$intersection_gene}\n";
	}
	close (OUTINTERSECTION);
}
close (PATHLIST);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
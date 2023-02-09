#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Statistics::Robust::Scale qw(MAD);
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
my @input_file_pathes = glob ("'D:/research work/Takifugu/RNAseq/03.statistics/03.Correlation/cuffnorm/*/genes.fpkm_table'");
#map {print "$_\n"} @input_file_pathes and die;
my $output_dir_path = "D:/research work/Takifugu/RNAseq/03.statistics/03.Correlation/";
#####################################################################################################
my (%output_file_pathes) = ();
foreach my $input_file_path (@input_file_pathes) {
	$input_file_path =~ /.*\/cuffnorm_([^_]+)_([^_]+)_([a-zA-Z0-9_]+)\/.*/;
	my $output_file_path = $output_dir_path."Fugu_"."input_expression_".ucfirst($2).".txt";
	$output_file_pathes{$output_file_path}{"$1_$3"} = $input_file_path;
}
#print Dumper (\%output_file_pathes) and die;
#####################################################################################################
foreach my $output_file_path (keys %output_file_pathes) {
	open (OUT, ">$output_file_path") or die "$!";
	my (@sample_ids, %fpkm) = ();
	foreach my $cluster (sort {$a cmp $b} keys %{$output_file_pathes{$output_file_path}}) {
		print "$output_file_path\t$cluster\n";
		my $input_file_path = $output_file_pathes{$output_file_path}{$cluster};
		open (IN, "<$input_file_path") or die "$!";
		my (@header) = ();
		while (<IN>) {
			chomp (my $data = $_);
			my @data = split (/\t/, $data);
			if ($data =~ /^tracking_id.*/) {
				map {$_ =~ s/([^_]+)_[^_]+_([a-zA-Z0-9_]+)_0/$1_$2/} @data;
				@header = @data;
				shift @data;
#				print @data and die;
				push (@sample_ids, @data);
			} else {
				for (my $i = 1; $i <= $#data; $i++) {
					$fpkm{$data[0]}{$header[$i]} = $data[$i];
				}
			}
		}
		close (IN);
	}
	print OUT "Gene\t", join ("\t", @sample_ids), "\n";
	foreach my $gene_id (sort {$a cmp $b} keys %fpkm) {
		print OUT "$gene_id";
		foreach my $sample_id (@sample_ids) {
			print OUT "\t$fpkm{$gene_id}{$sample_id}";
		}
		print OUT "\n";
	}
	close (OUT);
}
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
#!/usr/bin/perl

use strict;
use warnings;

my @files_pathes = glob "$ARGV[0]/*.vcf";
open (OUT, ">$ARGV[1]") or die "$!";

my %vcf_data = ();
my @order = ();

foreach my $file_path (@files_pathes) {
	(my $file_name = $file_path) =~ s/.*\/(.*)\.vcf/$1/;
	push (@order, $file_name);
	open (IN, "<$file_path") or die "$!";
	while (<IN>) {
		chomp (my $vcf_data = $_);
		my @vcf_data = split (/\t/, $vcf_data);
		if ($vcf_data[6] eq "PASS") {
			$vcf_data{$vcf_data[0]}{$vcf_data[1]}{$file_name} = $vcf_data[9]
		}
	}
}
close (IN);

foreach my $chr (sort {$a <=> $b} keys %vcf_data) {
	foreach my $pos (sort {$a <=> $b} keys %{$vcf_data{$chr}}) {
		my @info = ();
		foreach my $sample (@order) {
			if (exists $vcf_data{$chr}{$pos}{$sample}) {
				push (@info, $vcf_data{$chr}{$pos}{$sample});
			} else {
				push (@info, "./.");
			}
		}
		print OUT join ("\t", @info) , "\n";
	}
}






#!/usr/bin/perl

use strict;
use warnings;

my @group1 = qw/AX TJ VN WZ YJ ZQ/;
my @group2 = qw/IN NP/;
my $pwd = $ARGV[0];
my $group3 = $ARGV[1];
my $output_filepath = $ARGV[2];
my %hash = ();

foreach my $group1 (@group1) {
	foreach my $group2 (@group2) {
		open (IN,"<$pwd/$group3/${group1}_vs_${group2}_${group3}_DrPEP.txt") or die "$!";
		while (<IN>) {
			chomp (my $file_data = $_);
			next if ($file_data =~ /^#.*/);
			my @file_data = split (/\t/,$file_data);
			if (exists $hash{$file_data[0]}){
				print "error: $file_data\n" if ($hash{$file_data[0]} ne $file_data);
			}else {
				$hash{$file_data[0]} = $file_data;
			}
		}
	}
}
open (OUT,">$output_filepath/domestic_vs_foreign_${group3}_DrPEP.txt") or die "$!";
#print OUT "#Gene_ID\tko_number\tblastp_identity_ratio\tDr_subject_gene\tDr_subject_gene_ko_number\n";
foreach my $key(keys %hash){
	print OUT "$hash{$key}\n";
}

close (IN);
close (OUT);


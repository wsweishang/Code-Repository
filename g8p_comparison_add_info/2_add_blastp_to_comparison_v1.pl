#!/usr/bin/perl

use strict;
use warnings;

open (INBLAST,"<$ARGV[0]") or die "$!";
my $folder_path = $ARGV[1];
chomp $folder_path;
my %blast_data = ();
while (<INBLAST>) {
	chomp (my $blast_data = $_);
	my @blast_data = split (/\t/,$blast_data);
	$blast_data{$blast_data[1]}{"identity_ratio"} = $blast_data[5];
	$blast_data{$blast_data[1]}{"subject"} = $blast_data[2];
}
close (INBLAST);

my @files_path = glob "${folder_path}/*.txt";
foreach my $file_path (@files_path) {
	(my $file_name = $file_path) =~ s/.*\/(.*)\.txt/$1/;
	open (OUT,">./matrix/indel/${file_name}_DrPEP.txt") or die "$!";
	open (IN,"<$file_path") or die "$!";
	while (<IN>) {
		chomp (my $file_data = $_);
		my @file_data = split (/\t/,$file_data);
		if (exists $blast_data{$file_data[0]}) {
			print OUT "$file_data[0]\t$blast_data{$file_data[0]}{'identity_ratio'}\t$blast_data{$file_data[0]}{'subject'}\n";
		} else {
			print OUT "$file_data[0]\tNA\tNA\n";
		}
	}
}
close (IN);
close (OUT);


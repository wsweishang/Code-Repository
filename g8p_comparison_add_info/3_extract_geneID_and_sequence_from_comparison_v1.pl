#!/usr/bin/perl

use strict;
use warnings;

my $folder_path = $ARGV[0];
my $fasta_path = $ARGV[1];
my $output_path = $ARGV[2];

open (INFASTA,"<$fasta_path") or die "$!";
my $geneID = ();
my %fasta = ();
while (<INFASTA>) {
	chomp (my $fasta_data = $_);
	if ($fasta_data =~ /^>([a-zA-Z0-9.]+)\s.*/) {
		$geneID = $1;
	} else {
		$fasta{$geneID} .= $fasta_data;
	}
}
close (INFASTA);

my @files_path = glob "$folder_path/*.txt";
my %geneID = ();
foreach my $file_path (@files_path) {
	open (IN,"<$file_path") or die "$!";
	while (<IN>) {
		chomp (my $file_data = $_);
#		next unless ($file_data =~ /^CI.*/);
		my @file_data = split (/\t/,$file_data);
		next if ($file_data[2] eq "NA");
		unless (exists $geneID{$file_data[2]}) {
			$geneID{$file_data[2]} = 1;
		}
	}
}
close (IN);

open (OUT,">$output_path") or die "$!";
#open (OUTERR,">") or die "$!";
foreach my $key (keys %geneID) {
	if (exists $fasta{$key}) {
		print OUT ">$key\n";
		print OUT "$fasta{$key}\n";
	} else {
#		print OUTERR "error : $key do not exists in fasta\n";
		print "error : $key do not exists in fasta\n";
	}
}


close (OUT);
#close (OUTERR);












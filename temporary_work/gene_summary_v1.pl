#!/usr/bin/perl

use strict;
use warnings;

my @files_path = glob "D:/download/*.txt";
open (OUT, ">D:/Grasscarp selected genes sharing high identities with known zebrafish genes.txt") or die "$!";

my %txt = ();
foreach my $file_path (@files_path) {
	(my $file_name = $file_path) =~ s/.*\/([^_]+)_([^_]+)_([^_]+)_AF.*kb_(.*)_gene.*/$1 $2 $3 $4/;
	open (IN, "<$file_path") or die "$!";
	while (<IN>) {
		chomp (my $txt = $_);
		next if ($txt =~ /^#.*/);
		my @txt = split (/\t/, $txt);
		if (exists $txt{$txt[0]}) {
			$txt{$txt[0]} .= "\t$file_name";
		} else {
			$txt{$txt[0]} = "$txt[1]\t$txt[2]\t$txt[8]\t$txt[5]\t$txt[6]\t\t\t$file_name";
		}
	}
}
close (IN);

print OUT "#Grasscarp gene\tHomologous zebrafish gene\tDescription of zebrafish gene\tIdentity ratio\tCoverage ratio\tFunction\tInvolved pathway\tcluster\n";
foreach my $key (sort {$a cmp $b} keys %txt) {
	print OUT "$txt{$key}\n";
}
close (OUT);












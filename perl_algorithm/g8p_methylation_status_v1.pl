#!/usr/bin/perl

use strict;
use warnings;

#my $files_folder_path = $ARGV[0];
#my @files_path = glob "$files_folder_path/*.cov";

my @files_path = glob "E:/raw_file_cov/*.cov";
#print @files_path;
my %count = ();
foreach my $file_path (@files_path) {
	(my $file_name = $file_path) =~ s/.*\/(.*)\.cov/$1/;
	open (INCOV,"<$file_path") or die "$!";
	open (OUT,">E:/all_stat.txt") or die "$!";
	while (<INCOV>) {
		chomp (my $cov_data = $_);
		my @cov_data = split (/\t/,$cov_data);
		my $result = sprintf ("%.2f",$cov_data[3]/100);
		if ($result >= 0 and $result < 0.1) {
			$count{"0-0.1"} ++;
		} elsif ($result >= 0.1 and $result < 0.2) {
		 	$count{"0.1-0.2"} ++;
		} elsif ($result >= 0.2 and $result < 0.3) {
		 	$count{"0.2-0.3"} ++;
		} elsif ($result >= 0.3 and $result < 0.4) {
		 	$count{"0.3-0.4"} ++;
		} elsif ($result >= 0.4 and $result < 0.5) {
		 	$count{"0.4-0.5"} ++;
		} elsif ($result >= 0.5 and $result < 0.6) {
		 	$count{"0.5-0.6"} ++;
		} elsif ($result >= 0.6 and $result < 0.7) {
		  	$count{"0.6-0.7"} ++;
		} elsif ($result >= 0.7 and $result < 0.8) {
		  	$count{"0.7-0.8"} ++;
		} elsif ($result >= 0.8 and $result < 0.9) {
		  	$count{"0.8-0.9"} ++;
		} elsif ($result >= 0.9 and $result <= 1) {
		  	$count{"0.9-1"} ++;
		} else {
			print "error\n";
		}
	}

	
#	undef (%count);
}
close (INCOV);
	print OUT "'0-0.1'\t$count{'0-0.1'}\n";
	print OUT "'0.1-0.2'\t$count{'0.1-0.2'}\n";
	print OUT "'0.2-0.3'\t$count{'0.2-0.3'}\n";
	print OUT "'0.3-0.4'\t$count{'0.3-0.4'}\n";
	print OUT "'0.4-0.5'\t$count{'0.4-0.5'}\n";
	print OUT "'0.5-0.6'\t$count{'0.5-0.6'}\n";
	print OUT "'0.6-0.7'\t$count{'0.6-0.7'}\n";
	print OUT "'0.7-0.8'\t$count{'0.7-0.8'}\n";
	print OUT "'0.8-0.9'\t$count{'0.8-0.9'}\n";
	print OUT "'0.9-1'\t$count{'0.9-1'}\n";
close (OUT);




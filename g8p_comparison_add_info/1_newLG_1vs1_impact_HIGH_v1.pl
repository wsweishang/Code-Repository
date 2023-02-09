#!/usr/bin/perl

use strict;
use warnings;

open (INFILESPATHLIST, "<$ARGV[0]");
my $type = $ARGV[1];

my @files = ();
while (<INFILESPATHLIST>) {
	chomp (my $file_path = $_);
	push (@files, $file_path);
}
close (INFILESPATHLIST);

my %compared_data=();
foreach my $file_a(@files){
	open (INCOMPA,"<$file_a");
	undef %compared_data;
	foreach my $compared_data (<INCOMPA>) {
		chomp $compared_data;
		next if ($compared_data =~ /^#.*/);
		my @compared_content = split (/\t/,$compared_data);
		next if ($compared_content[1] =~ /.*circ$/);
		next if ($compared_content[4] == 0);
		$compared_data{$compared_content[0]} = 1;
	}
	foreach my $file_b(@files){
		next if ($file_a eq $file_b);
		open (INCOMPB,"<$file_b");
		$file_a =~ /\/([A-Z]{2})\//;
		my $file_a_id = $1;
		$file_b =~ /\/([A-Z]{2})\//;
		my $file_b_id = $1;
		open (OUT,">./result/${type}/${file_b_id}_vs_${file_a_id}_${type}.txt");
		foreach my $compare_data (<INCOMPB>) {
			chomp $compare_data;
			next if ($compare_data =~ /^#.*/);
			my @compare_content = split (/\t/,$compare_data);
			next if ($compare_content[1] =~ /.*circ$/);
			next if ($compare_content[4] == 0);
			unless (exists $compared_data{$compare_content[0]}) {
				if ($compare_content[4]){
					print OUT "$compare_data\n";
				}
			}
		}
		undef $file_a_id;
		undef $file_b_id;
	}
}

close (INCOMPA);
close (INCOMPB);
close (OUT);














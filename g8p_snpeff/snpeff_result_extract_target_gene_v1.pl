#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (GENEIDPATH, "<D:/t.txt") or die "$!";
open (TARGETEFFECT, "<D:/t.txt") or die "$!";
open (SNPEFFSUMMARY, "<D:/t.txt") or die "$!";
open (OUT, ">D:/out.txt") or die "$!";
#####################################################################################################
my (%target_gene) = ();
while (<GENEIDPATH>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	my ($name, $path) = @data[0..1];
	open (IN, "<$path") or die "$!";
	while (<IN>) {
		chomp (my $gene_id = $_);
		next if ($gene_id =~ /^#.*/);
		push (@{$target_gene{$gene_id}}, $name);
	}
	close (IN);
}
close (GENEIDPATH);
#####################################################################################################
my (%target_effect) = ();
while (<TARGETEFFECT>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	$target_effect{$data} = 1;
}
close (TARGETEFFECT);
#####################################################################################################
while (<SNPEFFSUMMARY>) {
	chomp (my $data = $_);
	if ($data =~ /^#.*/) {
		print OUT "$data\tcluster\n";
	}
	my @data = split (/\t/, $data);
	$data[6] =~ /.*(CI\d{8}_\d{8}_\d{8}).*/ or die;
	if (exists $target_gene{$1}) {
		if (exists $target_effect{$data[4]}) {
			print OUT "$data\t", join ("|", @{$target_gene{$1}}), "\n";
		}
	}
}
close (SNPEFFSUMMARY);
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
#!/usr/bin/perl

use strict;
use warnings;

open (INTXT, "<D:/2/il/GrassCarp_Pi_introduction_divides_local_0.95.annotation.txt") or die "$!";
open (INDATASET, "<D:/2/Dataset1.txt") or die "$!";
open (OUT, ">D:/2/GrassCarp_Pi_introduction_divides_local_0.95_out.txt") or die "$!";

my $set_number = 0;
my %dataset_data = ();
while (<INDATASET>) {
	chomp (my $dataset_data = $_);
	next if ($dataset_data =~ /^Species.*/);
	my @dataset_data = split (/\t/, $dataset_data);
	$dataset_data{$dataset_data[2]} = "$dataset_data[0]\t$dataset_data[1]\t$dataset_data[2]\t$dataset_data[4]";
	$set_number++;
}
close (INDATASET);

my $flag = 0;
my $number = 0;
my $all_number = 0;
print OUT "#Matched gene number/all gene number in Grass carp/all gene number in other species : \n";
print OUT "#Gene\tKEGG_annotation\tSpecies\tGene name\tGene symbol\tReference\n";
while (<INTXT>) {
	chomp (my $txt_data = $_);
	next if ($txt_data =~ /^#.*/);
	my @txt_data = split (/\t/, $txt_data);
	foreach my $key (keys %dataset_data) {
		if ($txt_data[4] =~ /.*\s$key[\s,].*/i) {
			print OUT "$txt_data[0]\t$txt_data[4]\t$dataset_data{$key}\t";
			$flag = 1;
		}
	}
	if ($flag eq 1) {
		print OUT "\n";
		$flag = 0;
		$number++;
	}
	$all_number++;
}
print "$number/$all_number/$set_number\n";
close (INTXT);
close (OUT);





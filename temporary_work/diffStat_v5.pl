#!/usr/bin/perl

use strict;
use warnings;

open (INVCF, "<E:/Grass carp/slaf_diffStat/GrassCarp.recode.vcf") or die "$!";
open (INSAMPLECODE, "<E:/Grass carp/slaf_diffStat/sample_code.txt") or die "$!";
open (OUT, ">E:/Grass carp/slaf_diffStat/out.txt") or die "$!";

my %sample_code = ();
while (<INSAMPLECODE>) {
	chomp (my $sample_code = $_);
	next if ($sample_code =~ /^#.*/);
	my @sample_code = split (/\t/, $sample_code);
	$sample_code{$sample_code[0]}{$sample_code[1]} = 1;
	$sample_code{$sample_code[-1]} = $sample_code[1];
}
close (INSAMPLECODE);

my @case_code = keys %{$sample_code{"case"}};
my @control_code = keys %{$sample_code{"control"}};
my @ID = ();
while (<INVCF>) {
	chomp (my $vcf_data = $_);
	if ($vcf_data =~ /^#.*/) {
		next if ($vcf_data =~ /^##.*/);
		@ID = split (/\t/, $vcf_data);
		next;
	}
	my @vcf_data = split (/\t/, $vcf_data);
	my %vcf_data = ();
	my %gh = ();
	for (my $i = 9 ; $i <= $#vcf_data ; $i++) {
		my @sample_data = split (/\:/, $vcf_data[$i]);
		if ($sample_data[0] eq "0/1") {
			$vcf_data{$sample_code{$ID[$i]}} += 1;
			$gh{$sample_code{$ID[$i]}} += 2;
		} elsif ($sample_data[0] eq "1/1") {
			$vcf_data{$sample_code{$ID[$i]}} += 2;
			$gh{$sample_code{$ID[$i]}} += 2;
		} elsif ($sample_data[0] eq "./.") {
			next;
		} elsif ($sample_data[0] eq "0/0") {
			$gh{$sample_code{$ID[$i]}} += 2;
			next;
		} else {
			print "error\n" and die;
		}
	}
	my @result = ();
	foreach my $population1 (@case_code) {
		my $case_allel_frequency = ();
		if (exists $vcf_data{$population1}) {
			$case_allel_frequency = $vcf_data{$population1} / $gh{$population1};
			
		} else {
			$case_allel_frequency = 0;
		}
		foreach my $population2 (@control_code) {
			my $control_allel_frequency = ();
			if (exists $vcf_data{$population2}) {
				$control_allel_frequency = $vcf_data{$population2} / $gh{$population2};
			} else {
				$control_allel_frequency = 0;
			}
			my $result = $case_allel_frequency - $control_allel_frequency;
			push (@result, $result);
			
		}
	}
	my $posc = grep {$_ > 0} @result;
	my $negc = grep {$_ < 0} @result;
	@result = map {abs $_} @result;
	if ($posc > 0 && $negc > 0) {
		print OUT "$vcf_data[0]\t$vcf_data[1]\t0\n";
	} else {
		@result = sort @result;
		if ($result[0] == 0) {
			$result[0] = 0;
		}
		print OUT "$vcf_data[0]\t$vcf_data[1]\t$result[0]\n";
	}
}
close (INVCF);
close (OUT);




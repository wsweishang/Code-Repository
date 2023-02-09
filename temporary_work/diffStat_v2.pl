#!/usr/bin/perl
#=======================================================================================================
use strict;
use warnings;
#=======================================================================================================
open (LIST, "<$ARGV[0]") or die "$!";
open (OUT, ">$ARGV[1]") or die "$!";
#=======================================================================================================
my %list_data = ();
my %list_divide = ();
while (<LIST>) {
	chomp (my $list_data = $_);
	my @list_data = split (/\t/, $list_data);
	for (my $i = 2 ; $i <= $#list_data ; $i++) {
		$list_data{$list_data[$i]}{"group"} = $list_data[0];
		$list_data{$list_data[$i]}{"population"} = $list_data[1];
		$list_data{$list_data[$i]}{"diploid"} = ($#list_data - 1) * 2;
	}
	push (@{$list_divide{$list_data[0]}}, $list_data[1]);
	
}
close (LIST);
#=======================================================================================================
my %vcf_data = ();
my %snp_site = ();
foreach my $vcf_path (keys %list_data) {
	open (VCF, "<$vcf_path") or die "$!";
	while (<VCF>) {
		chomp (my $vcf_data = $_);
		next if ($vcf_data =~ /^#.*/);
		my @vcf_data = split (/\t/, $vcf_data);
		my @format_data = split (/\:/, $vcf_data[8]);
		my @sample_data = split (/\:/, $vcf_data[9]);
		my %format = ();
		for (my $i = 0 ; $i <= $#format_data ; $i++) {
			$format{$format_data[$i]} = $sample_data[$i];
		}
		if ($format{"GT"} eq "0/1") {
			$vcf_data{"$vcf_data[0]\t$vcf_data[1]\t$list_data{$vcf_path}{'population'}"}{$vcf_data[4]} += 1;
		} elsif ($format{"GT"} eq "1/1") {
			$vcf_data{"$vcf_data[0]\t$vcf_data[1]\t$list_data{$vcf_path}{'population'}"}{$vcf_data[4]} += 2;
		} else {
			print "error\n" and die;
		}
		$snp_site{"$vcf_data[0]\t$vcf_data[1]"} = 1;
	}
}
close (VCF);
#=======================================================================================================
my @case_population = @{$list_divide{"case"}};
my @control_population = @{$list_divide{"control"}};
my @genotype = qw/A T C G/;
my $diploid = 20;
foreach my $key (sort (keys %snp_site)) {
	foreach my $genotype (@genotype) {
		my @result = ();
		foreach my $population1 (@case_population) {
			my $case_allel_frequency = ();
			if (exists $vcf_data{"$key\t$population1"}{$genotype}) {
				my $case_allel_frequency = $vcf_data{"$key\t$population1"}{$genotype} / $diploid;
			} else {
				my $case_allel_frequency = 0;
			}
			foreach my $population2 (@control_population) {
				my $control_allel_frequency = ();
				if (exists $vcf_data{"$key\t$population2"}{$genotype}) {
					my $control_allel_frequency = $vcf_data{"$key\t$population2"}{$genotype} / $diploid;
				} else {
					my $control_allel_frequency = 0;
				}
				my $result = $case_allel_frequency - $control_allel_frequency;
				push (@result, $result);
			}
		}
#		my $posc = grep {$_ > 0} @result;
#		my $negc = grep {$_ < 0} @result;
#		@result = map {abs $_} @result;
		my $posc = ();
		my $negc = ();
		foreach my $gh (@result) {
			if ($gh > 0) {
				$posc += 1;
			} elsif ($gh < 0) {
				$negc += 1;
			}
			$gh = abs $gh;
		}
		if ($posc > 0 && $negc > 0) {
			print OUT "$key\tundirect\n";
		} else {
			@result = sort @result;
			print OUT "$key\t$result[0]\n";
		}
	}
}
close (OUT);




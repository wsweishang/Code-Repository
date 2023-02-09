#!/usr/bin/perl

use strict;
use warnings;

open (INVCF, "<D:/research work/Grass carp/LDheatmap/snp_filtered.vcf") or die "$!";
open (OUTGENOTYPE, ">D:/research work/Grass carp/LDheatmap/genotype.txt") or die "$!";
open (OUTPOSITION, ">D:/research work/Grass carp/LDheatmap/position.txt") or die "$!";

my %vcf_data = ();
while (<INVCF>) {
	chomp (my $vcf_data = $_);
	next if ($vcf_data =~ /^#.*/);
	my @vcf_data = split (/\t/, $vcf_data);
	next if ($vcf_data[4] =~ /.*,.*/);
	my $ref_genotype = $vcf_data[3];
	my $alt_genotype = $vcf_data[4];
	for (my $i = 9 ; $i <= 18 ; $i++) {
		if ($vcf_data[$i] =~ /^0\/0.*/) {
			my $genotype = "$ref_genotype/$ref_genotype";
			$vcf_data{$vcf_data[0]}{"$i"}{$vcf_data[1]} = $genotype;
		} elsif ($vcf_data[$i] =~ /^0\/1.*/) {
			my $genotype = "$ref_genotype/$alt_genotype";
			$vcf_data{$vcf_data[0]}{"$i"}{$vcf_data[1]} = $genotype;
		} elsif ($vcf_data[$i] =~ /^1\/1.*/) {
			my $genotype = "$alt_genotype/$alt_genotype";
			$vcf_data{$vcf_data[0]}{"$i"}{$vcf_data[1]} = $genotype;
		} elsif ($vcf_data[$i] =~ /^\.\/\..*/) {
			my $genotype = "NA";
			$vcf_data{$vcf_data[0]}{"$i"}{$vcf_data[1]} = $genotype;
		} else {
			print "error\n" and die;
		}
	}
}
close (INVCF);

my @position = sort {$a <=> $b} keys %{$vcf_data{"24"}{"9"}};
for (my $i = 0 ; $i <= $#position ; $i++) {
	my $site = $i+1;
	print OUTGENOTYPE "SNP$site\t";
	print OUTPOSITION "$position[$i]\n";
}
print OUTGENOTYPE "\n";

foreach my $key1 (sort {$a <=> $b} keys %{$vcf_data{"24"}}) {
	foreach my $key2 (sort {$a <=> $b} keys %{$vcf_data{"24"}{$key1}}) {
		print OUTGENOTYPE "$vcf_data{'24'}{$key1}{$key2}\t";
	}
	print OUTGENOTYPE "\n";
}
close (OUTGENOTYPE);
close (OUTPOSITION);




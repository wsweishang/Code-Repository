#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (INTXT, "<D:/research work/Grass carp/LDheatmap/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt") or die "$!";
open (INVCF, "<D:/research work/Grass carp/LDheatmap/snp_filtered.vcf") or die "$!";
open (OUTGENOTYPE, ">D:/research work/Grass carp/LDheatmap/genotype.txt") or die "$!";
open (OUTPOSITION, ">D:/research work/Grass carp/LDheatmap/position.txt") or die "$!";

my %txt_data = ();
while (<INTXT>) {
	chomp (my $txt_data = $_);
	next if ($txt_data =~ /^LG.*/);
	my @txt_data = split (/\t/, $txt_data);
	$txt_data{$txt_data[1]}{"chr"} = $txt_data[0];
	$txt_data{$txt_data[1]}{"start"} = $txt_data[3];
	$txt_data{$txt_data[1]}{"length"} = $txt_data[2];
	$txt_data{$txt_data[1]}{"orientation"} = $txt_data[-1];
}

my %vcf_data = ();
while (<INVCF>) {
	chomp (my $vcf_data = $_);
	next if ($vcf_data =~ /^#.*/);
	my @vcf_data = split (/\t/, $vcf_data);
	next unless (exists $txt_data{$vcf_data[0]});
#	next if ($vcf_data =~ /.*\.\/\..*/);
	my $ref_genotype = $vcf_data[3];
	my $alt_genotype = $vcf_data[4];
	my $real_site = ();
	if ($txt_data{$vcf_data[0]}{"orientation"} eq "+") {
		$real_site = $txt_data{$vcf_data[0]}{"start"} + $vcf_data[1] - 1;
	} elsif ($txt_data{$vcf_data[0]}{"orientation"} eq "-") {
		$real_site = $txt_data{$vcf_data[0]}{"length"} - $vcf_data[1] + $txt_data{$vcf_data[0]}{"start"};
	}
	for (my $i = 9 ; $i <= $#vcf_data ; $i++) {
		if ($vcf_data[$i] =~ /^0\/0.*/) {
			my $genotype = "$ref_genotype/$ref_genotype";
			$vcf_data{$txt_data{$vcf_data[0]}{"chr"}}{"$i"}{"$real_site"} = $genotype;
		} elsif ($vcf_data[$i] =~ /^0\/1.*/) {
			my $genotype = "$ref_genotype/$alt_genotype";
			$vcf_data{$txt_data{$vcf_data[0]}{"chr"}}{"$i"}{"$real_site"} = $genotype;
		} elsif ($vcf_data[$i] =~ /^1\/1.*/) {
			my $genotype = "$alt_genotype/$alt_genotype";
			$vcf_data{$txt_data{$vcf_data[0]}{"chr"}}{"$i"}{"$real_site"} = $genotype;
		} 
		elsif ($vcf_data[$i] =~ /^\.\/\..*/) {
			my $genotype = "NA";
			$vcf_data{$txt_data{$vcf_data[0]}{"chr"}}{"$i"}{"$real_site"} = $genotype;
		} 
#		elsif ($vcf_data[$i] =~ /^1\/0.*/) {
#			my $genotype = "$alt_genotype/$ref_genotype";
#			$vcf_data{$txt_data{$vcf_data[0]}{"chr"}}{"$i"}{"$real_site"} = $genotype;
#		} 
		else {
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




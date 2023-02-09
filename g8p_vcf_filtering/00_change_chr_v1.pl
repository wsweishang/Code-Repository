#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (INSCAFFOLDLIST, "<D:/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt") or die "$!";
open (INVCF, "<D:/Ref.gatk_raw.snp.vqsr.filter.vcf") or die "$!";
open (OUT, ">D:/Ref.gatk_raw.snp.vqsr.filter_changeID.vcf") or die "$!";

my %scaffold_list_data = ();
while (<INSCAFFOLDLIST>) {
	chomp (my $scaffold_list_data = $_);
	next if ($scaffold_list_data =~ /^LG.*/);
	my @scaffold_list_data = split (/\t/, $scaffold_list_data);
	$scaffold_list_data{$scaffold_list_data[1]}{"chr"} = $scaffold_list_data[0];
	$scaffold_list_data{$scaffold_list_data[1]}{"start"} = $scaffold_list_data[3];
	$scaffold_list_data{$scaffold_list_data[1]}{"length"} = $scaffold_list_data[2];
	$scaffold_list_data{$scaffold_list_data[1]}{"orientation"} = $scaffold_list_data[4];
}
close (INSCAFFOLDLIST);

my %vcf_data = ();
my $head = ();
while (<INVCF>) {
	 if ($_ =~ /^#.*/) {
	 	$head .= $_;
		next;
	}
	chomp (my $vcf_data = $_);
	my @vcf_data = split (/\t/, $vcf_data);
	next unless ($scaffold_list_data{$vcf_data[0]});
	if ($scaffold_list_data{$vcf_data[0]}{"orientation"} eq "+") {
		$vcf_data[1] = $scaffold_list_data{$vcf_data[0]}{"start"} + $vcf_data[1] - 1;
		$vcf_data[0] = $scaffold_list_data{$vcf_data[0]}{"chr"};
		$vcf_data{$vcf_data[0]}{$vcf_data[1]} = join ("\t", @vcf_data);
	} elsif ($scaffold_list_data{$vcf_data[0]}{"orientation"} eq "-") {
		$vcf_data[1] = $scaffold_list_data{$vcf_data[0]}{"length"} - $vcf_data[1] + $scaffold_list_data{$vcf_data[0]}{"start"};
		$vcf_data[0] = $scaffold_list_data{$vcf_data[0]}{"chr"};
		$vcf_data{$vcf_data[0]}{$vcf_data[1]} = join ("\t", @vcf_data);
	}
}
close (INVCF);

print OUT $head;
foreach my $chr (sort {$a <=> $b} keys %vcf_data) {
	foreach my $site (sort {$a <=> $b} keys %{$vcf_data{$chr}}) {
		print OUT "$vcf_data{$chr}{$site}\n";
	}
}
close (OUT);



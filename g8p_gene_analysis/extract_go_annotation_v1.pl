#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;

open (TARGETGO, "<D:/research work/Grass_carp/Gene/GO_summary/target_go_term.txt") or die "$!";
open (GOTERM, "<D:/research work/Grass_carp/Gene/GO_summary/C_idella_female_eggNOG.fa.emapper.annotations") or die "$!";
open (PATH, "<D:/research work/Grass_carp/Gene/GO_summary/workshop_filepath_list.txt") or die "$!";
open (OUT, ">D:/research work/Grass_carp/Gene/GO_summary/go_summary_v3.txt") or die "$!";

my (@target_go_term, %target_go_term) = ();
while (<TARGETGO>) {
	chomp (my $target_go = $_);
	next if ($target_go =~ /^#.*/);
	my @target_go = split (/\t/, $target_go);
	push (@target_go_term, $target_go[1]);
	$target_go_term{$target_go[1]} = $target_go[2];
#	print "@target_go_term\n" and die;
}
close (TARGETGO);

my %go_term = ();
while (<GOTERM>) {
	chomp (my $go_term = $_);
	next if ($go_term =~ /^#.*/);
	my @go_term = split (/\t/, $go_term);
	if ($go_term[6] and $go_term[8]) {
		my @go_number = split (/,/, $go_term[6]);
		my @ko_number = split (/,/, $go_term[8]);
		foreach my $ko_number (@ko_number) {
			$ko_number = substr ($ko_number, 3);
			map {$go_term{$ko_number}{"goterm"}{$_} = 1} @go_number;
			if ($go_term[5]) {
				$go_term{$ko_number}{"gene_name"} = $go_term[5];
			} else {
				$go_term{$ko_number}{"gene_name"} = "NA";
			}
		}
	}
}
close (GOTERM);

my (@group, %gene_id) = ();
while (<PATH>) {
	chomp (my $path = $_);
	next if ($path =~ /^#.*/);
	my @path = split (/\t/, $path);
	push (@group, $path[0]);
	open (TXT, "<$path[2]") or die "$!";
	while (<TXT>) {
		chomp (my $txt = $_);
		next if ($txt =~ /^#.*/);
		my @txt = split (/\t/, $txt);
		$gene_id{$txt[0]}{"ko_number"} = $txt[1];
		$gene_id{$txt[0]}{$path[0]} = 1;
	}
	close (TXT);
}
close (PATH);

#print OUT "#Gene_id\tGene_Name\t", join ("\t", @group), "\tGO Terms\n";
foreach my $gene (sort {$a cmp $b} keys %gene_id) {
	my $ko_number = $gene_id{$gene}{"ko_number"};
	if (exists $go_term{$ko_number}{"goterm"}) {
		print OUT "$gene\t$go_term{$ko_number}{'gene_name'}\t";	
		foreach my $target_go_term (@target_go_term) {
			if (exists $go_term{$ko_number}{"goterm"}{$target_go_term}) {
				print OUT "$target_go_term{$target_go_term}\t";
			} else {
				print OUT "\t";
			}
		}
		foreach my $group (@group) {
			if (exists $gene_id{$gene}{$group}) {
				print OUT "$group\t";
			} else {
				print OUT "\t";
			}
		}
		print OUT join ("..", sort {$a cmp $b} keys %{$go_term{$ko_number}{"goterm"}}), "\n";
	}
}
close (OUT);

printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
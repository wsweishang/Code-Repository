#!/usr/bin/perl

#use v5.10.0;
use strict;
use warnings;
#use Data::Dumper;
#use Math::round;
#use File::copy;
#use File::stat;
#use File::Find;
#use Net::FTP;
#use threads;
#use threads::shared;
#use Thread;

open (INLIST, "<D:/research work/Grass_carp/Venn/file_path.txt") or die "$!";
open (OUT, ">D:/research work/Grass_carp/Venn/all_selected_shared_gene.txt") or die "$!";

my %gene_id = ();
while (<INLIST>) {
	chomp (my $list = $_);
	my ($file_path, $file_name) = (split (/\t/, $list))[0..1];
	open (INTXT, "<$file_path") or die "$!";
	while (<INTXT>) {
		chomp (my $gene_id = $_);
		$gene_id{$gene_id}{$file_name} = 1;
	}
}
close (INLIST);
close (INTXT);

print OUT "gene_id\tshared_num\tgroup\n";
foreach my $gene_id (sort {$a cmp $b} keys %gene_id) {
	my @gh = sort {$a cmp $b} keys (%{$gene_id{$gene_id}});
	my $num = @gh;
	print OUT "$gene_id\t$num";
	foreach my $gh (@gh) {
		print OUT "\t$gh";
	}
	print OUT "\n";
}
close (OUT);









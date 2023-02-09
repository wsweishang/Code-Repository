#!/usr/bin/perl

use strict;
use warnings;

open (INFASTA, "<$ARGV[0]") or die "$!";
open (INTXT, "<$ARGV[1]") or die "$!";
open (OUT, ">$ARGV[2]") or die "$!";

my %fasta_data = ();
my $gene_ID = ();
while (<INFASTA>) {
	chomp (my $fasta_data = $_);
	if ($fasta_data =~ /^>([a-zA-Z0-9_]+).*/) {
		$gene_ID = $1;
	} else {
		$fasta_data{$gene_ID} = $fasta_data;
	}
}
close (INFASTA);

while (<INTXT>) {
	chomp (my $txt_data = $_);
	next if ($txt_data !~ /^LG.*/);
	my @txt_data = split (/\t/, $txt_data);
	if ($txt_data[2] eq "gene") {
		$txt_data[8] =~ /.*([a-zA-Z0-9]+)$/;
		my $gene_name = $1;
		if (exists $fasta_data{$gene_name}) {
			print OUT ">$gene_name\n";
			print OUT "$fasta_data{$gene_name}\n";
		} 
	}
}
close (INTXT);
close (OUT);

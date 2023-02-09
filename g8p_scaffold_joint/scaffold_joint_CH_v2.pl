#!/usr/bin/perl

use strict;
use warnings;

open (INFASTA,"<D:/scaffold.fasta") or die "$!";
open (INTXT,"<D:/order.txt") or die "$!";
open (OUTNEWFASTA,">D:/new.fasta") or die "$!";

my %scaffold=();
my $scaffold_ID=();
while (<INFASTA>) {
	chomp (my $infasta = $_);
	if ($infasta =~ /^>(.*)/){
		$scaffold_ID = $1;	
	} else {
		$scaffold{$scaffold_ID} = $infasta;
	}
}
close (INFASTA);

my $LG=0;
while (<INTXT>) {
	chomp (my $inorder = $_);
	next if ($inorder =~ /^LG.*/);
	my @inorder = split (/\t/,$inorder);
	if ($LG == 0) {
		
	} elsif ($LG != $inorder[0]){
		print OUTNEWFASTA "\n";
	} else {
		print OUTNEWFASTA "N" x10;
	}
	if ($LG != $inorder[0]) {
		print OUTNEWFASTA ">LG$inorder[0]\n";
		$LG = $inorder[0];
	}
	if ($inorder[2] eq "+"){
		print OUTNEWFASTA "$scaffold{$inorder[1]}";
	} else {
		my $rev_seq = reverse $scaffold{$inorder[1]};
		$rev_seq =~ tr/ATCG/TAGC/;
		print OUTNEWFASTA "$rev_seq";
	}
}
print OUTNEWFASTA "\n";
close (INTXT);
close (OUTNEWFASTA);




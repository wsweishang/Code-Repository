#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (IN,"<G:/grasscarp_8populations/result/Scaffold/C_idella_female_scaffolds_fasta_out.txt") or die "$!";
open (OUT,">G:/grasscarp_8populations/result/Scaffold/C_idella_female_scaffolds_fasta_out_1.txt") or die "$!";
open (INORDER,"<G:/grasscarp_8populations/manuscript/Scaffold/Cid_AnchorLGmapNew_0624_263scafford.txt") or die "$!";

my @infasta=<IN>;
my @inorder=<INORDER>;
my %fasta=();
my $fasta_ID=();
foreach my $infasta(@infasta){
	chomp $infasta;
	if ($infasta=~/^>.*/){
		$fasta_ID=substr($infasta,1);
	}
	$infasta=substr($infasta,-100)="";
	$fasta{$fasta_ID}=$infasta;
}
my $inorder=();


foreach $inorder(@inorder){
	chomp $inorder;
	my @order=split (/\t/,$inorder);
	if (exists $fasta{$order[2]}){
		say OUT ">".$order[2];
		say OUT $fasta{$order[2]};
	}
}

close (IN);
close (OUT);
close (INORDER);











#!/usr/bin/perl

use strict;
use warnings;

#open (INPEP,"<G:/result/Danio_rerio.GRCz11.pep.all.fa") or die "$!";
#open (OUT,">G:/result/Danio_rerio_removelinefeeds.fasta") or die "$!";
#
#foreach my $pep(<INPEP>){
#	if ($pep=~/^(>.*[\.][0-9]+)\s[pep].*\n/){
#		$pep=$1;
#		print OUT "\n$pep\n";
#		next;
#	}elsif ($pep!~/^>.*\n/){
#		chomp $pep;
#		print OUT "$pep";
#		next;
#	}else{
#		print "error!$pep\n";
#	}
#}
#
#close (INPEP);
#close (OUT);

#=========================================================================================
open (INTXT,"<G:/result/Danio_rerio_removelinefeeds.fasta") or die "$!";
open (OUT,">G:/result/Danio_rerio_length.txt") or die "$!";

my %txt=();
foreach my $txt(<INTXT>){
	if ($txt=~/^>.*/){
		chomp $txt;
		print OUT "$txt ";
		next;
	}elsif ($txt!~/^>.*/){
		chomp $txt;
		my $length=length $txt;
		print OUT "$length\n";
		next;
	}else{
		print "error!$txt\n";
	}
}

close (INTXT);
close (OUT);


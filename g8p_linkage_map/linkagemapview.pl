#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

open (IN,"<G:/mapthis.txt") or die "$!";
open (OUT,">G:/1.txt") or die "$!";

my %lg=();
foreach my $lg(<IN>){
	chomp $lg;
	my @lg=split(/\t/,$lg);
	push (@{$lg{$lg[0]}{"scaffold"}},"$lg[0]\t$lg[2]\t$lg[1]");
	push (@{$lg{$lg[0]}{"cm"}},"LG$lg[0]\t$lg[3]\t$lg[1]");
}
close (IN);
print OUT "LG\tPosition\tSNP\n";
for (my $i=1;$i<=24;$i++){
	foreach my $fh(@{$lg{$i}{"scaffold"}}){
		print OUT "$fh\n";
	}
	foreach my $gh(@{$lg{$i}{"cm"}}){
		print OUT "$gh\n";
	}
}

close (OUT);










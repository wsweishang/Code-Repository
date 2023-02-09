#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

my @Files=glob 'D:/*.txt';
foreach my $singlefile(@Files){
	say $singlefile;
	open (IN,$singlefile) or die "$!";
	while (<IN>){
		open (OUT,">$singlefile");
		say OUT "weishang";
		close (OUT);
	}
}

my @a = qw/a b c/;
my @b = qw/e d f/;

my @c = glob "{@{[join ',', @a]}}_{@{[join ',', @b]}}";
map {print "$_\n"} @c;
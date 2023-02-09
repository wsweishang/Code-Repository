#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

say length("weishang");

#substr EXPR,OFFSET,LENGTH,REPLACEMENT
#substr EXPR,OFFSET,LENGTH
#substr EXPR,OFFSET

my $s = "The black cat climbed the green tree";
my $color = substr $s, 4, 5;     # black
my $middle = substr $s, 4, -11;  # black cat climbed the
my $end = substr $s, 14;         # climbed the green tree
my $tail = substr $s, -4;        # tree
my $z = substr $s, -4, 2;        # tr

my $name = 'fred';
substr($name, 4) = 'dy';         # $name is now 'freddy'
my $null = substr $name, 6, 2;   # returns "" (no warning)
my $oops = substr $name, 7;      # returns undef, with warning
substr($name, 7) = 'gap';        # raises an exception

my $s1 = "The black cat climbed the green tree";
my $z1 = substr $s1, 14, 7, "jumped from";    # climbed
                                              # $s1 is now "The black cat jumped from the green tree"

my $x = '1234';
for (substr($x,1,2)) {
     $_ = 'a';   print $x,"\n";    # prints 1a4
     $_ = 'xyz'; print $x,"\n";    # prints 1xyz4
     $x = '56789';
     $_ = 'pq';  print $x,"\n";    # prints 5pq9
}

my $x1 = '1234';
for (substr($x1, -3, 2)) {
     $_ = 'a';   print $x1,"\n";   # prints 1a4, as above
     $x1 = 'abcdefg';
     print $_,"\n";                # prints f
}










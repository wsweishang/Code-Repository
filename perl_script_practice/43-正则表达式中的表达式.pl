#!/usr/bin/perl

use strict;
use warnings;
#use Data::Dump qw(dump);

my $str="my name is weishang";
my ($out1)=$str=~/(?x)   is   /g;
print "out1 => [$out1] => $str\n";
my ($out2)=$str=~/   (?x)is/g;
print "out2 => [$out2] => $str\n";
my ($out3)=$str=~/(?x:   is\s   )weishang/g;
print "out3 => [$out3] => $str\n";
my ($out4)=$str=~/(?x:   is\s   ) weishang/g;
print "out4 => [$out4] => $str\n";


$str=~/\w+(?{ show() })/;
sub show{
	print "ooh!\n";
}


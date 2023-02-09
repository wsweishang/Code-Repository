#!/usr/bin/perl

use strict;
use warnings;

print "inter : ";
my $n=<STDIN>;
chomp $n;
print "$n\n";
$n=($n>=3)?0:$n+1;   #条件运算符：当$n大于等于3的时候，$n为0，否则$n+1
print "$n\n";


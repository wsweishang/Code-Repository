#!/usr/bin/perl

use strict;
use warnings;

print "inter : ";
my $n=<STDIN>;
chomp $n;
print "$n\n";
$n=($n>=3)?0:$n+1;   #�������������$n���ڵ���3��ʱ��$nΪ0������$n+1
print "$n\n";


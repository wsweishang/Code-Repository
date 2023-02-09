#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

my $array="|USA|China|England|France|Russia|Germany|Greece|Egypt";
my @str=split(/\|/,$array);

say @str;
say $str[0];
shift @str;
say $str[0];
@str=reverse @str;
say @str;
say $str[0];
#$str[0]="Poland";
#my $str=join("1",@array);
#say $str;
#my @str2=reverse @array;
#say @str2;






















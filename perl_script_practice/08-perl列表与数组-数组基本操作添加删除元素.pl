#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;













#通过Perl内置的List::Util模块，这些函数都经过C优化，执行速度非常快
#(1)求数组的和：不需要一个一个地累加，直接调用sum函数
use List::Util qw/sum/;
my @array1 = (10, 20, 30, 40);
my $sum = sum @array1;       # 得到 100
say $sum;

#(2)求数组的最大、最小值：不需要逐个比较，直接调用max和min函数
use List::Util qw/max min/;
my @array2 = (10, -1, 6, 25, 8);
my $max = max @array2;           # 得到 25
say $max;
my $min = min @array2;           # 得到 -1
say $min;

#(3)如果是按照字符串排列的最大、最小值呢？调用 maxstr和 minstr函数
use List::Util qw/maxstr minstr/;
my @array3 = ("Beijing", "Shanghai", "Guangzhou", "Chengdu", "Nanjing");
my $maxstr = maxstr @array3;     # 得到 Shanghai
say $maxstr;
my $minstr = minstr @array3;     # 得到 Beijing
say $minstr;









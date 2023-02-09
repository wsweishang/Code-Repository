#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;













#ͨ��Perl���õ�List::Utilģ�飬��Щ����������C�Ż���ִ���ٶȷǳ���
#(1)������ĺͣ�����Ҫһ��һ�����ۼӣ�ֱ�ӵ���sum����
use List::Util qw/sum/;
my @array1 = (10, 20, 30, 40);
my $sum = sum @array1;       # �õ� 100
say $sum;

#(2)������������Сֵ������Ҫ����Ƚϣ�ֱ�ӵ���max��min����
use List::Util qw/max min/;
my @array2 = (10, -1, 6, 25, 8);
my $max = max @array2;           # �õ� 25
say $max;
my $min = min @array2;           # �õ� -1
say $min;

#(3)����ǰ����ַ������е������Сֵ�أ����� maxstr�� minstr����
use List::Util qw/maxstr minstr/;
my @array3 = ("Beijing", "Shanghai", "Guangzhou", "Chengdu", "Nanjing");
my $maxstr = maxstr @array3;     # �õ� Shanghai
say $maxstr;
my $minstr = minstr @array3;     # �õ� Beijing
say $minstr;









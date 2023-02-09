#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

my $num=ord 'E';
my $word=chr(69);
say "The ASCII is : $num";
say "The word is : $word";

my @arr = (1,2,3,4,5);
my @map1 = map $_*2,@arr;
say join (',',@arr);   #join：内插分隔符
say join (',',@map1);

my $wei = "1;2;3;4;5";
my @wei1 = split (';',$wei);   #split函数把字符串进行分割,并把分割后的结果放入数组中
say @wei1;
my @wei2 = reverse (@wei1);
say @wei2;


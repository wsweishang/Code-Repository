#!/perl/bin/perl

use v5.10.0;
use warnings;
use strict;

my $var = "Hi";   #声明一个标量
my $steam01 = $var .', '. "Weishang\n";   #两个标量的相连以"."进行，若要引入空格，可通过" "的方式
my $steam02 = $steam01 . qq[How are you?];   #qq代表双引号；q代表单引号
my $len = length"$steam02";   #length函数用于计算串的长度，并返回位数

say "$steam02";
say "\nThe number of letters is $len";
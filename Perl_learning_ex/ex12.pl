#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#九九乘法表
#用一个for循环嵌套另一个for循环的用意在于，使第二个for循环完再循环第一个for的下一次循环

for ($a=1;$a<=9;$a=$a+1){
	for ($b=1;$b<=9;$b=$b+1){
		my $c=$a*$b;
		say "$a * $b = $c";
	}
}
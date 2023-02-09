#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#找出200以内，两数相乘等于240的有哪些
#用一个for循环嵌套另一个for循环的用意在于，使第二个for循环完再循环第一个for的下一次循环

for ($a=1;$a<200;$a=$a+1){
	for($b=1;$b<200;$b=$b+1){
		if($a*$b==240){
			say "$a * $b = 240"
		}
	}
}
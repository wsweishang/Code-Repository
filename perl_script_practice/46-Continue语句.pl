#!/usr/bin/perl

use strict;
use warnings;

#continue 块通常在条件语句再次判断前执行，可用在 while 和 foreach 循环中。

#while 循环中 continue 语句语法格式如下所示：
#while (condition) {
#	statement(s);
#} continue {
#	statement(s);
#}
#foreach 循环中 continue 语句语法格式如下所示：
#foreach $a (@listA) {
#	statement(s);
#} continue {
#	statement(s);
#}

#while 循环中使用 continue 语句：
my $a = 0;
while ($a < 3) {
	print "a = $a\n";
} continue {
	$a = $a + 1;
}
#a = 0
#a = 1
#a = 2

#foreach 循环中使用 continue 语句：  
my @list = (1, 2, 3, 4, 5);
foreach $a (@list) {
   print "a = $a\n";
} continue {
   last if ($a == 4);
}
#a = 1
#a = 2
#a = 3
#a = 4




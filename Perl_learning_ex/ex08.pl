#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

my %hash = ("1"=>"first","2"=>"second");   #注意哈希定义的格式

print join (",",%hash);
print "\n";

while(($a,$b) = each %hash){   #each是一个遍历，分别将哈希中的每一组key值和value值分别定义给a、b两个标量
	print "$a->$b\n";
	print "$a\n";
	print "$b\n";
}

my @a = keys (%hash);   #keys函数用于将哈希中的所有key值赋给某一数组
my @b = values (%hash);   #values函数用于将哈希中的所有value值赋给某一数组

print "\nkeys: @a\n";
print "values: @b\n";

my ($c,$d) = %hash;   #与上面的遍历类似，但由于没有each，所以只有一轮循环，只有第一组值
print "hash: $c\n";
print "hash: $d\n";


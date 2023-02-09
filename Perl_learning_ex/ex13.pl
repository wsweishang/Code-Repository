#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

sub func{              #设置func自定义方法
	my ($a,$b) = @_;
	return $a-$b;
}
#say "Please input a number";
#my $a = <STDIN>;
#say "Please input a number";
#my $b = <STDIN>;

my $a = $ARGV[0];   #控制台空格输入参数，自动按顺序保存
my $b = $ARGV[1];
my $s = func($a,$b);   #调用函数func
say "结果是 $s";
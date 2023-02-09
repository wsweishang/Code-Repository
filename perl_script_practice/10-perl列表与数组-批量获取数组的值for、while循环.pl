#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#================================================
#perl列表与数组-批量获取数组的值for/while循环
#================================================

#两种分别提取数组中全部元素的循环方法
my @languages=("perl","R","python","shell");
for (my$i=0;$i<@languages;$i++){
	say "$i = $languages[$i]";
}

my $ii=0;
foreach my $languages(@languages){
	say "$ii = $languages";
	$ii++;
}

#==============================
#sort函数
#==============================
#排序特殊变量$a，$b
#按字符排序用cmp
my @languages2=qw/fortuan lisp c c++ Perl python java/;
my @languages2_sorted=sort {$a cmp $b} @languages2;   #倒序将$a，$b调换位置即可
say join(" ",@languages2);   #join函数
say join(" ",@languages2_sorted);   #结果按字母表从前向后排序

#按数值排序用<=>
my @languages3=(8,2,32,1,4,16);
my @languages3_sorted=sort {$a <=> $b} @languages3;
say join(" ",@languages3);
say join(" ",@languages3_sorted);   #结果按首位数字从小到大排序














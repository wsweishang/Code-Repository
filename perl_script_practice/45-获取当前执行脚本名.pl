#/usr/bin/perl

use strict;
use warnings;

my $pgm=$0;   #$0获取的是脚本路径+脚本名，即"C:/Users/ASUS/eclipse-workspace/perl_script_practice/45-获取当前执行脚本名.pl"
$pgm=~s/.*\/(.*)/$1/;   #正则表达式s/.*\/(.*)/$1/是将脚本全名中的路径去掉，得到"45-获取当前执行脚本名.pl"
print "$0\n";   #$0的值是"C:/Users/ASUS/eclipse-workspace/perl_script_practice/45-获取当前执行脚本名.pl"
print "$pgm";   #现在$pgm的值是"45-获取当前执行脚本名.pl"









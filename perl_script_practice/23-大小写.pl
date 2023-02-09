#!/usr/bin/perl

use v5.10.0;
#use strict;
#use warnings;

my $str="May god have mercy on your soul";

#perl涉及字符串的大小写的转换开关有\U、\L、\u、\l、\E五个
#\U:此开关的功能是将其后的所有字符转换成大写
$str=~s/(\w+)/\U$1/gi;
say $str;

#\L:此开关的功能是将其后的所有字符转换成小写
$str=~s/(\w+)/\L$1/gi;
say $str;

#\u:只将紧跟其后的第一个字符转换成大写
$str=~s/(\w+)/\u$1/gi;
say $str;

#\E:关闭大小写转换功能，在\E之后的字符串关闭不受影响
my $newstr="\UMay god have \Emercy on your soul";
say $newstr;

#此外perl还支持uc、lc、ucfirst、lcfirst操作符
my $newnewstr="May god have mercy on your soul";
say uc ($newnewstr);
say lc ($newnewstr);
say ucfirst ($newnewstr);
say lcfirst ($newnewstr);






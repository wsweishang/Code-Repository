#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

my $string="I can learn much from perlcn.com";

my $str=substr($string,22,10);
say $str;   #返回结果：perlcn.com
$str=substr($string,-10,10);
say $str;   #返回结果：perlcn.com
$str=substr($string,-10,-4);
say $str;   #返回结果：perlcn
$str=substr($string,-10,-4)="PERLCN";
say $str;   #返回结果：PERLCN

#substr EXPR,OFFSET
#substr EXPR,OFFSET,LENGTH
#substr EXPR,OFFSET,LENGTH,REPLACEMENT
#substr可以指定偏移量
#如果偏移量OFFSET为正，则从左边开始计数，如果为负，则从右边开始计数
#如果未指定 length，substr函数取出string后，从指定的offset开始运行，返回offset到末尾的所有字符
#如果指定了length，则只会返回从offset开始，长度为length的字符
#如果length为负值，则substr返回从offset开始到字符串结尾的值，少于length 指明的字符
#换句话说就是先获取从offset开始到字符串结束的所有字符，然后从字符串的末尾减去length个长度的字符串，剩下的字符串作为 substr的返回值
#也可以将匹配到的字符替换为其他字符，原字符串的值也会同时被修改

$str=substr($string,-10,-4)="the PERLCN";
say $string;   #返回结果：I can learn much from the PERLCN.com
say $str;
$str=substr($string,-10)="";
say $string;
say $str;





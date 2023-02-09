#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#perl中grep的使用
#grep是perl里面的一个列表筛选函数，功能还是不错的。
#grep有2种表达方式:
#1. grep  BLOCK  LIST
#2. grep  EXPR,  LIST
#BLOCK表示一个code块,通常用{}表示;EXPR表示一个表达式,通常是正则表达式。LIST是要匹配的列表。
#示例：
#统计匹配表达式的列表元素个数
my @array=();
my $num = grep /^cds$/i,@array;
my $m=grep {$array[$_] eq "CDS"}  @array;
#在标量上下文里,grep返回匹配中的元素个数;在列表上下文里,grep返回匹配中的元素的一个列表。





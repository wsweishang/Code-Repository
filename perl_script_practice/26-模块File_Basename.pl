#! /usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use File::Basename;

#========================================================================
#File:Basename模块可以将一个文件的所在路径，文件名称，文件后缀区分开
#========================================================================
#使用use File::Basename模块后，可以调用三种常用的函数：fileparse, basename, dirname.
#1. fileparse： 输入参数全路径名称和后缀列表；返回三个值：文件名，路径，后缀，并存放在列表中
#2. basename: 输入参数全路径名称和后缀列表; 返回文件名
#3. dirname: 输入参数全路径名称; 返回文件路径

my $fullname='/home/qilzhao/xxxxxxxxxx.pl';
my @suffixlist=qw(.pl .txt .sv .v);
my ($name, $path, $suffix)=fileparse($fullname, @suffixlist);

say "name=$name";   #返回结果：name=xxxxxxxxxx，文件名
say "path=$path";   #返回结果：path=/home/qilzhao/，路径
say "suffix=$suffix";   #返回结果：suffix=.pl，后缀

$name=fileparse($fullname, @suffixlist);
say "name=$name";   #返回结果：name=xxxxxxxxxx，文件名

my $basename=basename($fullname, @suffixlist);
say "basename=$basename";   #返回结果：basename=xxxxxxxxxx，文件名

my $dirname = dirname($fullname);
say "dirname=$dirname";   #返回结果：dirname=/home/qilzhao，路径














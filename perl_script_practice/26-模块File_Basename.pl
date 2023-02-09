#! /usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use File::Basename;

#========================================================================
#File:Basenameģ����Խ�һ���ļ�������·�����ļ����ƣ��ļ���׺���ֿ�
#========================================================================
#ʹ��use File::Basenameģ��󣬿��Ե������ֳ��õĺ�����fileparse, basename, dirname.
#1. fileparse�� �������ȫ·�����ƺͺ�׺�б���������ֵ���ļ�����·������׺����������б���
#2. basename: �������ȫ·�����ƺͺ�׺�б�; �����ļ���
#3. dirname: �������ȫ·������; �����ļ�·��

my $fullname='/home/qilzhao/xxxxxxxxxx.pl';
my @suffixlist=qw(.pl .txt .sv .v);
my ($name, $path, $suffix)=fileparse($fullname, @suffixlist);

say "name=$name";   #���ؽ����name=xxxxxxxxxx���ļ���
say "path=$path";   #���ؽ����path=/home/qilzhao/��·��
say "suffix=$suffix";   #���ؽ����suffix=.pl����׺

$name=fileparse($fullname, @suffixlist);
say "name=$name";   #���ؽ����name=xxxxxxxxxx���ļ���

my $basename=basename($fullname, @suffixlist);
say "basename=$basename";   #���ؽ����basename=xxxxxxxxxx���ļ���

my $dirname = dirname($fullname);
say "dirname=$dirname";   #���ؽ����dirname=/home/qilzhao��·��














#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#perl��grep��ʹ��
#grep��perl�����һ���б�ɸѡ���������ܻ��ǲ���ġ�
#grep��2�ֱ�﷽ʽ:
#1. grep  BLOCK  LIST
#2. grep  EXPR,  LIST
#BLOCK��ʾһ��code��,ͨ����{}��ʾ;EXPR��ʾһ�����ʽ,ͨ����������ʽ��LIST��Ҫƥ����б�
#ʾ����
#ͳ��ƥ����ʽ���б�Ԫ�ظ���
my @array=();
my $num = grep /^cds$/i,@array;
my $m=grep {$array[$_] eq "CDS"}  @array;
#�ڱ�����������,grep����ƥ���е�Ԫ�ظ���;���б���������,grep����ƥ���е�Ԫ�ص�һ���б�





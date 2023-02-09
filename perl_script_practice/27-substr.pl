#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

my $string="I can learn much from perlcn.com";

my $str=substr($string,22,10);
say $str;   #���ؽ����perlcn.com
$str=substr($string,-10,10);
say $str;   #���ؽ����perlcn.com
$str=substr($string,-10,-4);
say $str;   #���ؽ����perlcn
$str=substr($string,-10,-4)="PERLCN";
say $str;   #���ؽ����PERLCN

#substr EXPR,OFFSET
#substr EXPR,OFFSET,LENGTH
#substr EXPR,OFFSET,LENGTH,REPLACEMENT
#substr����ָ��ƫ����
#���ƫ����OFFSETΪ���������߿�ʼ���������Ϊ��������ұ߿�ʼ����
#���δָ�� length��substr����ȡ��string�󣬴�ָ����offset��ʼ���У�����offset��ĩβ�������ַ�
#���ָ����length����ֻ�᷵�ش�offset��ʼ������Ϊlength���ַ�
#���lengthΪ��ֵ����substr���ش�offset��ʼ���ַ�����β��ֵ������length ָ�����ַ�
#���仰˵�����Ȼ�ȡ��offset��ʼ���ַ��������������ַ���Ȼ����ַ�����ĩβ��ȥlength�����ȵ��ַ�����ʣ�µ��ַ�����Ϊ substr�ķ���ֵ
#Ҳ���Խ�ƥ�䵽���ַ��滻Ϊ�����ַ���ԭ�ַ�����ֵҲ��ͬʱ���޸�

$str=substr($string,-10,-4)="the PERLCN";
say $string;   #���ؽ����I can learn much from the PERLCN.com
say $str;
$str=substr($string,-10)="";
say $string;
say $str;





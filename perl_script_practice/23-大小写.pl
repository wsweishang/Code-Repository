#!/usr/bin/perl

use v5.10.0;
#use strict;
#use warnings;

my $str="May god have mercy on your soul";

#perl�漰�ַ����Ĵ�Сд��ת��������\U��\L��\u��\l��\E���
#\U:�˿��صĹ����ǽ����������ַ�ת���ɴ�д
$str=~s/(\w+)/\U$1/gi;
say $str;

#\L:�˿��صĹ����ǽ����������ַ�ת����Сд
$str=~s/(\w+)/\L$1/gi;
say $str;

#\u:ֻ���������ĵ�һ���ַ�ת���ɴ�д
$str=~s/(\w+)/\u$1/gi;
say $str;

#\E:�رմ�Сдת�����ܣ���\E֮����ַ����رղ���Ӱ��
my $newstr="\UMay god have \Emercy on your soul";
say $newstr;

#����perl��֧��uc��lc��ucfirst��lcfirst������
my $newnewstr="May god have mercy on your soul";
say uc ($newnewstr);
say lc ($newnewstr);
say ucfirst ($newnewstr);
say lcfirst ($newnewstr);






#!/usr/bin/perl

use strict;
use warnings;

#continue ��ͨ������������ٴ��ж�ǰִ�У������� while �� foreach ѭ���С�

#while ѭ���� continue ����﷨��ʽ������ʾ��
#while (condition) {
#	statement(s);
#} continue {
#	statement(s);
#}
#foreach ѭ���� continue ����﷨��ʽ������ʾ��
#foreach $a (@listA) {
#	statement(s);
#} continue {
#	statement(s);
#}

#while ѭ����ʹ�� continue ��䣺
my $a = 0;
while ($a < 3) {
	print "a = $a\n";
} continue {
	$a = $a + 1;
}
#a = 0
#a = 1
#a = 2

#foreach ѭ����ʹ�� continue ��䣺  
my @list = (1, 2, 3, 4, 5);
foreach $a (@list) {
   print "a = $a\n";
} continue {
   last if ($a == 4);
}
#a = 1
#a = 2
#a = 3
#a = 4




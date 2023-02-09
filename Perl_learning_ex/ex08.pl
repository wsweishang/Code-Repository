#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

my %hash = ("1"=>"first","2"=>"second");   #ע���ϣ����ĸ�ʽ

print join (",",%hash);
print "\n";

while(($a,$b) = each %hash){   #each��һ���������ֱ𽫹�ϣ�е�ÿһ��keyֵ��valueֵ�ֱ����a��b��������
	print "$a->$b\n";
	print "$a\n";
	print "$b\n";
}

my @a = keys (%hash);   #keys�������ڽ���ϣ�е�����keyֵ����ĳһ����
my @b = values (%hash);   #values�������ڽ���ϣ�е�����valueֵ����ĳһ����

print "\nkeys: @a\n";
print "values: @b\n";

my ($c,$d) = %hash;   #������ı������ƣ�������û��each������ֻ��һ��ѭ����ֻ�е�һ��ֵ
print "hash: $c\n";
print "hash: $d\n";


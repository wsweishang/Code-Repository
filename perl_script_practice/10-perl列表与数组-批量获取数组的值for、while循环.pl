#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#================================================
#perl�б�������-������ȡ�����ֵfor/whileѭ��
#================================================

#���ֱַ���ȡ������ȫ��Ԫ�ص�ѭ������
my @languages=("perl","R","python","shell");
for (my$i=0;$i<@languages;$i++){
	say "$i = $languages[$i]";
}

my $ii=0;
foreach my $languages(@languages){
	say "$ii = $languages";
	$ii++;
}

#==============================
#sort����
#==============================
#�����������$a��$b
#���ַ�������cmp
my @languages2=qw/fortuan lisp c c++ Perl python java/;
my @languages2_sorted=sort {$a cmp $b} @languages2;   #����$a��$b����λ�ü���
say join(" ",@languages2);   #join����
say join(" ",@languages2_sorted);   #�������ĸ���ǰ�������

#����ֵ������<=>
my @languages3=(8,2,32,1,4,16);
my @languages3_sorted=sort {$a <=> $b} @languages3;
say join(" ",@languages3);
say join(" ",@languages3_sorted);   #�������λ���ִ�С��������














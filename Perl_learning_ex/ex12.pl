#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#�žų˷���
#��һ��forѭ��Ƕ����һ��forѭ�����������ڣ�ʹ�ڶ���forѭ������ѭ����һ��for����һ��ѭ��

for ($a=1;$a<=9;$a=$a+1){
	for ($b=1;$b<=9;$b=$b+1){
		my $c=$a*$b;
		say "$a * $b = $c";
	}
}
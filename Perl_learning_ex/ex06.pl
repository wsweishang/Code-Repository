#!/perl/bin/perl

use v5.10.0;
use warnings;
use strict;

print "Please enter your name\n";

my $v_in = <STDIN>;   #��ȡ����̨���������
print "Your name is" . " " . $v_in . "Do you want to be Weishang's son?\nY/N\n";
chomp ($v_in);   #chomp�������ڼ�ȥĳ�����Ļ��з���chop�������ڽ�ȥĳ�������һ���ַ�

my $n_in = <STDIN>;
chomp ($n_in);   #��Ҫȥ���س������ܽ��бȶ�
if ($n_in eq "Y") {   #�������ֵΪY
	print "Oh!" . " " . $v_in . " " . "has successfully become the son of Weishang";   #���ӡ������������
} else {
	print "What a pity!\n";   #�����ӡ������������
}

	

#/usr/bin/perl

use strict;
use warnings;

my $pgm=$0;   #$0��ȡ���ǽű�·��+�ű�������"C:/Users/ASUS/eclipse-workspace/perl_script_practice/45-��ȡ��ǰִ�нű���.pl"
$pgm=~s/.*\/(.*)/$1/;   #������ʽs/.*\/(.*)/$1/�ǽ��ű�ȫ���е�·��ȥ�����õ�"45-��ȡ��ǰִ�нű���.pl"
print "$0\n";   #$0��ֵ��"C:/Users/ASUS/eclipse-workspace/perl_script_practice/45-��ȡ��ǰִ�нű���.pl"
print "$pgm";   #����$pgm��ֵ��"45-��ȡ��ǰִ�нű���.pl"









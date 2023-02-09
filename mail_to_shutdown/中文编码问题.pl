#!/perl/bin/perl

use strict;
use warnings;
use Encode;

my $str = "κ��";
Encode::_utf8_on($str);
print length($str) . "\n";
Encode::_utf8_off($str);
print length($str) . "\n";
# gbk encoding chinese
my $a = "china----κ��";
Encode::_utf8_on($a);
print encode("GBK",$a),"\n";
my $strb =~ s/\W+//g;
my $b = "china----κ��";
$strb = decode("GBK",$b);
print encode("GBK",$strb),"\n";



#use 5.016;
#use utf8;
#binmode(STDIN, ':encoding(utf8)');
#binmode(STDOUT, ':encoding(utf8)');
#binmode(STDERR, ':encoding(utf8)');
#say "���";
##����ͻ��������
##�����������Ĵ���Ļ�
#use 5.016;
#use utf8;
#binmode(STDIN, ':encoding(gbk)');
#binmode(STDOUT, ':encoding(gbk)');
#binmode(STDERR, ':encoding(gbk)');
#say "���";
##�Ϳ����������������Ϊʲô�أ�
##windows xp��Ĭ��ʹ�� gbk ���룬�����㡡encoding(gbk)������������������







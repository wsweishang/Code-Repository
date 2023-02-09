#!/perl/bin/perl

use strict;
use warnings;
use Encode;

my $str = "魏上";
Encode::_utf8_on($str);
print length($str) . "\n";
Encode::_utf8_off($str);
print length($str) . "\n";
# gbk encoding chinese
my $a = "china----魏上";
Encode::_utf8_on($a);
print encode("GBK",$a),"\n";
my $strb =~ s/\W+//g;
my $b = "china----魏上";
$strb = decode("GBK",$b);
print encode("GBK",$strb),"\n";



#use 5.016;
#use utf8;
#binmode(STDIN, ':encoding(utf8)');
#binmode(STDOUT, ':encoding(utf8)');
#binmode(STDERR, ':encoding(utf8)');
#say "你好";
##结果就会出现乱码
##而如果是下面的代码的话
#use 5.016;
#use utf8;
#binmode(STDIN, ':encoding(gbk)');
#binmode(STDOUT, ':encoding(gbk)');
#binmode(STDERR, ':encoding(gbk)');
#say "你好";
##就可以正常输出，这是为什么呢？
##windows xp　默认使用 gbk 编码，所以你　encoding(gbk)　后能正常看到中文







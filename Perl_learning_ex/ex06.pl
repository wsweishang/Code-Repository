#!/perl/bin/perl

use v5.10.0;
use warnings;
use strict;

print "Please enter your name\n";

my $v_in = <STDIN>;   #读取控制台输入的数据
print "Your name is" . " " . $v_in . "Do you want to be Weishang's son?\nY/N\n";
chomp ($v_in);   #chomp函数用于减去某变量的换行符；chop函数用于截去某变量最后一个字符

my $n_in = <STDIN>;
chomp ($n_in);   #先要去掉回车，才能进行比对
if ($n_in eq "Y") {   #如果输入值为Y
	print "Oh!" . " " . $v_in . " " . "has successfully become the son of Weishang";   #则打印······
} else {
	print "What a pity!\n";   #否则打印······
}

	

#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
#use FindBin qw($Bin $Script);
#use File::Basename qw(basename dirname);
#use Cwd qw(abs_path getcwd);
#use List::Util qw(sum max min);

#=============================================================================
#Getopt::Long模块是用来在命令行中传递参数的，比之@ARGV，其强大有过之而无不及
#=============================================================================

#先声明这些变量
my @libs=();
my %flags=();
my ($verbose,$all,$help,$sd,$test,$step,$type)=();
#像哈希一样定义
GetOptions(
		'help!'=>\$help,
		'step:i'=>\$step,
		'sd:i'=>\$sd,
		'type=s'=>\$type,
		'lib=s'=>\@libs,
		'flag=s'=>\%flags,
		'test|t:s'=>\$test,
		'all|everthing|universe:s'=>\$all,
);

#'help!'    后接!的选项不接收变量（也就是讲后面不需要加参数-help来使用就行了），只要命令行中出现了这个参数，就会默认是1，!是用来设置打开和关闭一个功能的
#'step:i'   后接：的选项会接受缺省为0或为空字符串的可选变量
#'type=s'   后接= 的字符串要求接字符串（s）、整数（i），或者浮点（f）等类型的变量
#'lib=s'    如果相关联的变量是个数组，如此处的@libs，那么选项可以多次出现，值可以被推到数组中
#'flag=s'   如果相关联的变量是个hash，那么就要求一对键=值（key=value），并被插入到hash里
#'test|t:s' |意同and，意思是参数可以传递给-test或-t，两者均可
#
#备注：		1、在匹配参数名的时候，Getoptions在缺省条件下会忽略大小写
#			2、默认参数可被简写为唯一的最短字符（首字母）
#			3、（例如，-f代表-flag，如遇相同的首字母时，会加上第二个字母区分）

#USGAE为帮助子程序

sub USAGE {                                  #使用了heredoc特性，格式：以=<<"EOF"起始，以相应EOF结尾，再在中间填写内容
	my $usage=<<"usage";
Manual:
Options:
  -verbose    whether do something
  -help       note
  -step       note
  -type       note
  -lib        test \@
  -flag       test \%
  ···
usage
	print $usage;
	exit;                                     #打印并退出            
}

&USAGE unless (!$help and $type);             #必须输入$help或$type等指定值，否则打印帮助文档，相当于报错

$step||=1;                                    #可设置$step默认值，$step为指定值or为1

print "\$verbose :$verbose\n";
print "\$help:$help\n";
print "\$step:$step\n";
print "\$type:$type\n";
print "\@libs:@libs\n";
print "\%flags:".Dumper(\%flags)."\n";
print "\$test:$test\n";
print "\$all:$all\n";



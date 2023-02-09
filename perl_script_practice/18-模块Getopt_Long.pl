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
#Getopt::Longģ�����������������д��ݲ����ģ���֮@ARGV����ǿ���й�֮���޲���
#=============================================================================

#��������Щ����
my @libs=();
my %flags=();
my ($verbose,$all,$help,$sd,$test,$step,$type)=();
#���ϣһ������
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

#'help!'    ���!��ѡ����ձ�����Ҳ���ǽ����治��Ҫ�Ӳ���-help��ʹ�þ����ˣ���ֻҪ�������г���������������ͻ�Ĭ����1��!���������ô򿪺͹ر�һ�����ܵ�
#'step:i'   ��ӣ���ѡ������ȱʡΪ0��Ϊ���ַ����Ŀ�ѡ����
#'type=s'   ���= ���ַ���Ҫ����ַ�����s����������i�������߸��㣨f�������͵ı���
#'lib=s'    ���������ı����Ǹ����飬��˴���@libs����ôѡ����Զ�γ��֣�ֵ���Ա��Ƶ�������
#'flag=s'   ���������ı����Ǹ�hash����ô��Ҫ��һ�Լ�=ֵ��key=value�����������뵽hash��
#'test|t:s' |��ͬand����˼�ǲ������Դ��ݸ�-test��-t�����߾���
#
#��ע��		1����ƥ���������ʱ��Getoptions��ȱʡ�����»���Դ�Сд
#			2��Ĭ�ϲ����ɱ���дΪΨһ������ַ�������ĸ��
#			3�������磬-f����-flag��������ͬ������ĸʱ������ϵڶ�����ĸ���֣�

#USGAEΪ�����ӳ���

sub USAGE {                                  #ʹ����heredoc���ԣ���ʽ����=<<"EOF"��ʼ������ӦEOF��β�������м���д����
	my $usage=<<"usage";
Manual:
Options:
  -verbose    whether do something
  -help       note
  -step       note
  -type       note
  -lib        test \@
  -flag       test \%
  ������
usage
	print $usage;
	exit;                                     #��ӡ���˳�            
}

&USAGE unless (!$help and $type);             #��������$help��$type��ָ��ֵ�������ӡ�����ĵ����൱�ڱ���

$step||=1;                                    #������$stepĬ��ֵ��$stepΪָ��ֵorΪ1

print "\$verbose :$verbose\n";
print "\$help:$help\n";
print "\$step:$step\n";
print "\$type:$type\n";
print "\@libs:@libs\n";
print "\%flags:".Dumper(\%flags)."\n";
print "\$test:$test\n";
print "\$all:$all\n";



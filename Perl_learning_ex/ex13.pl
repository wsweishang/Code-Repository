#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

sub func{              #����func�Զ��巽��
	my ($a,$b) = @_;
	return $a-$b;
}
#say "Please input a number";
#my $a = <STDIN>;
#say "Please input a number";
#my $b = <STDIN>;

my $a = $ARGV[0];   #����̨�ո�����������Զ���˳�򱣴�
my $b = $ARGV[1];
my $s = func($a,$b);   #���ú���func
say "����� $s";
#!/perl/bin/perl

use v5.10.0;
use warnings;
use strict;

my $var = "Hi";   #����һ������
my $steam01 = $var .', '. "Weishang\n";   #����������������"."���У���Ҫ����ո񣬿�ͨ��" "�ķ�ʽ
my $steam02 = $steam01 . qq[How are you?];   #qq����˫���ţ�q��������
my $len = length"$steam02";   #length�������ڼ��㴮�ĳ��ȣ�������λ��

say "$steam02";
say "\nThe number of letters is $len";
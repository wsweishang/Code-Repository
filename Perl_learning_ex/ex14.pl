#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

my $word = "please help me";
if ($word =~ /Please/){   #=~Ϊƥ�䣬!~Ϊ��ƥ�䣬˫б���м�ΪҪƥ����ַ���Ӧע��perl���ִ�Сд
	say "polite";
}else {
	say "not polite";
}
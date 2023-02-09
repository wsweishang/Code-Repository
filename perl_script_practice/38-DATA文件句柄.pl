#!/usr/bin/perl

use strict;
use warnings;

#��̫���д��һ��perl������Ҫ�����½�һ���ļ������ԣ�ÿ�ξ��úܷ��������ֲ��ò���ô����û�뵽ԭ��perl�Ѿ��ṩ�˽�������������DATA
#����÷�̫����̫perl�ˣ��Ժ���Ҳ����Ҫʹ���½��ļ��ı�������
#<IN>���ԴӴ򿪵ľ��IN�л�����ݣ�<STDIN>���Դӱ�׼����������ݣ����Ƶأ�<DATA> �ļ��������ֱ�Ӵ�ִ�����Ľű��л�ȡ���ݣ������Ǵ������л��ߴ���һ���ļ����ȡ
#<DATA> ����ȡ�����ݱ�����ÿ���ű�ĩβ�����ⳣ��__DATA__֮��ͬʱ�������Ҳ��־�Žű����߼�����

#Ӣ�Ľ��ͣ�
#A Virtual File In Perl
#It has been occurred a lot of times that one has to test a code using data from a file.
#It can be anything like checking for a pattern in a file to taking some input.
#If you want to check the code without opening the file and reading it.
#One can use the __DATA__ marker provided by perl as a pseudo-datafile.
#Steps to follow:
#1) At the end of the code use __DATA__ marker and copy paste or write the contents of the file you wish to test exactly from the next line of _DATA_.
#2) Use while (){ -- your code here -- }.
#Output of the above program will be ��there��.

while (<DATA>){
	chomp $_;
	print $_;
}

while (<DATA>){
	chomp $_;
	print "Found" if $_ =~ /(t\w+)/;
	print "$1\n";
}
#ע�⣺�ű���������while(<DATA>)��ֻ��ǰһ�������ã���Ϊǰһ���Ѿ��������ļ���β
__DATA__
hello there how r u
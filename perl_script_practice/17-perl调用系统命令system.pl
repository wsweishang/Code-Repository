#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#======================================
#perl����ϵͳ����system
#======================================

my $dir="/home/manager/perl_script/";   #��perl�е���ϵͳ����ʱ������ʹ�þ���·��������������·������һ�������У����ڲ�ķ�ʽʹ�ã�����鿴
my @files=glob("$dir/fasta_files/*fasta");   #*fasta��ʾ��fastaΪ��׺���ļ�
my @files1=glob("$dir/fasta_files/1111111*");   #1111111*��ʾ��1111111��ͷ���ļ�
for my $i (@files){
	print "$i\n" or die "$!";
	print "blastall -i $i -d $dir/blastdb/ref.fa -e 1e-10 -p blastp -m 8 -o $i.out\n" or die "$!";
	system("blastall -i $i -d $dir/blastdb/ref.fa -e 1e-10 -p blastp -m 8 -o $i.out") or die "$!";   #system��������ϵͳ����Ὣ�ַ������������в�����
	`blastall -i $i -d $dir/blastdb/ref.fa -e 1e-10 -p blastp -m 8 -o $i.out` or die "$!";   #system����������һ��``�����������������������ʹ��
	system("perl 17.pl");   #�������е�perl 17.pl����ָ���Ҳ��ϵͳ������system����������perl�е�����һ��perl����
	my $err=system("blastall -i $i -d $dir/blastdb/ref.fa -e 1e-10 -p blastp -m 8 -o $i.out");   #��system������������ʱ�᷵��0������ʱ���ش��󱨾�
	if ($err){   #ifѭ������$errΪ�����ӡ$err�����󱨾�
		print "$err\n";
	}
}

my $result=();
#��perl��ϵͳ���������ַ�ʽ��һ����system(cmd),��һ����`system`
$result = system('ls');   #����Ľ�������᷵�ظ�$result,����ֱ�Ӵ�ӡ����Ļ
$result = `ls`;   #���ܻ�ȡ�������ִ�н��
#���Ҫ����ϵͳ����Ȼ��������ִ�еĽ��������Ҫʹ��`cmd`,������system


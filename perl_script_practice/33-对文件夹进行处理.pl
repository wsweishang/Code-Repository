#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#perl���ļ��д���
#��perl���������ļ����������ļ� opendir()��ȡĿ¼Ȩ����readdir()��ȡĿ¼���ļ�
#ָ��һ��Ŀ¼ opendir ( DIR, $dirname ) || die...
#��perl���������ļ����������ļ�
#opendir()��ȡĿ¼Ȩ����readdir()��ȡĿ¼���ļ�
my $dirname1 = "/tmp";         #ָ��һ��Ŀ¼
my $filename=();
opendir (DIR,$dirname1 ) || die "Error in opening dir \$dirname1";
while(($filename = readdir(DIR))){
	print("$filename");       #ѭ�������Ŀ¼�µ��ļ�
}
closedir (DIR);
#������ÿ���ļ�����һ��
my %h=();
my $dirname="/home/bmk/";
opendir (DIR,$dirname) || die "Error in opening dir \$dirname";
while (($filename=readdir(DIR))){
	open (FILE,"/home/bmk/".$filename)|| die "can not open the file \$filename";
	open (OUT,">/home/bmk/$filename.bak")|| die "can not open the \$filename.bakn";
	while (<FILE>){
		print OUT "$_";
	}
}
closedir (DIR);


#readdir������һ���� opendir �򿪵�Ŀ¼�����ȡĿ¼��¼Ҳ�����ļ������÷����£�
readdir (DIRHANDLE);
closedir (DIRHANDLE);
#�ڱ��������У�readdir����������һ��Ŀ¼��¼������������undef�����б����У��������ڸ�Ŀ¼������ʣ�µļ�¼�����ʣ��û�м�¼�ˣ���ô������ؿ�����һ�����б����磺
opendir (THISDIR, ".") or die "serious dainbramage: $!";
my @allfiles = readdir (THISDIR);
closedir (THISDIR);
print "@allfiles\n";
#����Ĵ�����һ�����ӡ����ǰĿ¼�������ļ������������⡰.���͡�..����¼��ʹ���������е�һ����
@allfiles = grep {$_ ne '.' and $_ ne '..'} readdir THISDIR;
@allfiles = grep {not /^[.][.]?\z/} readdir THISDIR;
@allfiles = grep {not /^\.{1,2}\z/} readdir THISDIR;
@allfiles = grep !/^\.\.?\z/, readdir THISDIR;
#Ϊ�˱������� .* �ļ���
@allfiles = grep !/^\./, readdir THISDIR;
#ֻ�ó��ı��ļ���
my @textfiles = grep -T, readdir THISDIR;
#���������ٿ������һ�����ӣ���Ϊ���readdir�Ľ�����ڵ�ǰĿ¼���ô������Ҫ�����Ľ���ϰ�Ŀ¼����ճ��ȥ������������
my $path=();
opendir (THATDIR, $path) or die "can't opendir $path: $!";
my @dotfile = grep { /^\./ && -f } map { "$path/$_" } readdir(THATDIR);
closedir (THATDIR);













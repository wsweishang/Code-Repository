#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

open (INFILE,">d:/test.txt");   #ע������б��
#">"��ʾ����ļ�ԭ�����ݣ�����д�룻">>"�������ļ�ԭ�����ݻ�����׷��������
print INFILE "test\n";
print INFILE "123\n";
close "INFILE";

my $file;
open (OUTFILE, "d:/test.txt");
while ($file = <OUTFILE>){   #ͨ��whileѭ����ӡ�ļ����ݣ�ֱ���ļ�����
	say "$file";
}
close (OUTFILE);

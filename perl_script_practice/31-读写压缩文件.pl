#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#perl��дgzѹ���ļ�
#perl ��������ļ�ͨ��Ϊ�ı��ļ����������ѹ���ļ�Ҳ�ǿ��Դ���ġ�����ͨ�ļ���д���ƣ���Ҫ��ȡ�ļ������ֻ�����б仯��
#�����ļ������
open (IN,"gzip -dc infile.gz|") or die "$!";
close (IN);
#����ļ������
open (OUT,"| gzip > outfile.gz") or die "$!";
close (OUT);









#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

my $num=150;
if ($num>100 and $num<200){   #if���Ը����жϣ��м���and����
	say "ok";
}

if ($num>100 && $num<200){   #&&��andЧ��һ��
	say "ok";
}

if ($num<100 or $num>200){   #or��ʾ������һ��������Ϊ��
	say "ok";
}

if ($num<100 || $num>200){   #||��orЧ��һ��
	say "ok";
}

if ($num<100 || ($num<200 && $num>100)){   #���Ը����ж���Ӷ����������ü������ţ�ʹ������������
	say "ok";
}
#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday tv_interval);
use Mail::POP3Client;
use MIME::Parser;
use MIME::Entity;

my $start_time=[gettimeofday];
#==============================================================
my $host="pop.163.com";
my $user="wswsweishang";
my $pass="ws454000";
#==============================================================
my $client=new Mail::POP3Client($user,$pass,$host);
my $parser=MIME::Parser->new;
my $mgrnum=$client->Count;

print "��ǰ�����ʼ�[$mgrnum]��\n";

for (my $i=1;$i<=$mgrnum;$i++){
	my $headandbody=$client->HeadAndBody($i);
	my $entity=$parser->parse_data($headandbody);
	$parser->decode_headers(1);
	print "From      = ",$entity->head->get('From');
	print "To        = ",$entity->head->get('To');
	print "Cc        = ",$entity->head->get('Cc');
	print "Subject   = ",$entity->head->get('Subject');
	print "MIME type = ",$entity->mime_type,"\n";
	print "Parts     = ",scalar $entity->parts,"\n";
	my $part_num=scalar $entity->parts;
	for my $part($entity->parts){
		print "\t",$part->mime_type,"\t",$part->bodyhandle,"\n";
	}
	print "=========================================================\n";
	exit if ((scalar $entity->parts)==1);
	#exit if ($i>=3);
}
my $interval=tv_interval($start_time,[gettimeofday]);
print "it take the time : $interval seconds\n";

#=====================================================================================================================
#�⼸�쾻������ȡ�ʼ���������,һ��ʼ����Щ������ģ��,�ܶ�����������,�������ĵ����е�üĿ.
#��˵˵����:
#Cygwin+Perl5.8+Mail::POP3Client+MIME::Parser+MIME::Entity+Time::HiRes
#Mail::POP3Client  ��װ�˻�����Net::POP3,ʹ����������
#MIME::Parser��MIME::Entity������,��������������ʽ��
#Time::HiRes������������ʱ��
#ǰ��ʼ��û��������Ϊʲô�ʼ�ͷ����Subjects�����������벻�ܽ���,���˷�RFC���ĵ�,����MIMR::Parser��֪����һ�� decode����
#### Automatically attempt to RFC 2047-decode the MIME headers?
#$parser->decode_headers(1);             ### default is false
#�������Ǻܷ����,�Ǻ�
#��$parser->parse_data($headandbody)��ʱ��Ὣ�ʼ�body�����ڱ���msg-PID-#.txt�ļ� ��,����Ҳ��������ӦĿ¼��
#=====================================================================================================================
#MIME�ʼ���ʽ
#����                                            |         ����             	      |       �����  
#Received                    |       ����·��            |   �����ʼ�������
#Return-Path                 |       �ظ���ַ            |   Ŀ���ʼ�������
#Delivered-To                |       ���͵�ַ            |   Ŀ���ʼ�������
#Reply-To                    |       �ظ���ַ            |   �ʼ��Ĵ�����
#From                        |       �����˵�ַ          |    �ʼ��Ĵ�����
#To                          |       �ռ��˵�ַ          |    �ʼ��Ĵ�����
#Cc                          |       ���͵�ַ            |   �ʼ��Ĵ�����
#Bcc                         |       ���͵�ַ            |   �ʼ��Ĵ�����
#Date                        |       ���ں�ʱ��          |    �ʼ��Ĵ�����
#Subject                     |       ����               |    �ʼ��Ĵ�����
#Message-ID                  |       ��ϢID             |    �ʼ��Ĵ�����
#MIME-Version                |       MIME�汾           |    �ʼ��Ĵ�����
#Content-Type                |       ���ݵ�����          |    �ʼ��Ĵ�����
#Content-Transfer-Encoding   |       ���ݵĴ�����뷽ʽ   |    �ʼ��Ĵ�����
#=====================================================================================================================





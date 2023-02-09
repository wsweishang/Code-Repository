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

print "当前共有邮件[$mgrnum]封\n";

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
#这几天净捣鼓收取邮件的问题了,一开始用了些基本的模块,很多问题解决不了,查找了文档才有点眉目.
#先说说环境:
#Cygwin+Perl5.8+Mail::POP3Client+MIME::Parser+MIME::Entity+Time::HiRes
#Mail::POP3Client  封装了基本的Net::POP3,使用起来更简单
#MIME::Parser是MIME::Entity的子类,就是用来解析格式的
#Time::HiRes用来计算消耗时间
#前面始终没有闹明白为什么邮件头里面Subjects中文总是乱码不能解析,翻了翻RFC的文档,看看MIMR::Parser才知道有一个 decode函数
#### Automatically attempt to RFC 2047-decode the MIME headers?
#$parser->decode_headers(1);             ### default is false
#解析还是很方便的,呵呵
#在$parser->parse_data($headandbody)的时候会将邮件body保留在本地msg-PID-#.txt文件 中,附件也保留在相应目录下
#=====================================================================================================================
#MIME邮件格式
#域名                                            |         含义             	      |       添加者  
#Received                    |       传输路径            |   各级邮件服务器
#Return-Path                 |       回复地址            |   目标邮件服务器
#Delivered-To                |       发送地址            |   目标邮件服务器
#Reply-To                    |       回复地址            |   邮件的创建者
#From                        |       发件人地址          |    邮件的创建者
#To                          |       收件人地址          |    邮件的创建者
#Cc                          |       抄送地址            |   邮件的创建者
#Bcc                         |       暗送地址            |   邮件的创建者
#Date                        |       日期和时间          |    邮件的创建者
#Subject                     |       主题               |    邮件的创建者
#Message-ID                  |       消息ID             |    邮件的创建者
#MIME-Version                |       MIME版本           |    邮件的创建者
#Content-Type                |       内容的类型          |    邮件的创建者
#Content-Transfer-Encoding   |       内容的传输编码方式   |    邮件的创建者
#=====================================================================================================================





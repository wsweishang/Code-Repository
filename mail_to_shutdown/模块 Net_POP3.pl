#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;
use Net::POP3;
#===========================================================================================
print "Mail host: ";
chomp(my $host = <STDIN>);
print "Mailbox username: ";
chomp(my $user = <STDIN>);
print "Mailbox password: ";
chomp(my $pass = <STDIN>);
#===========================================================================================
#my $host="pop.163.com";
#my $user="wswsweishang";
#my $pass="ws454000";
#===========================================================================================
#��¼
my $conn = Net::POP3->new($host) or die("ERROR: Unable to connect. ");   # initiate connection, default timeout = 120 sec
my $numMsg = $conn->login($user, $pass) or die("ERROR: Unable to login. ");   # login
#===========================================================================================
#�ʼ���
# display number of messages
if ($numMsg > 0) {
    print "Mailbox now has $numMsg message(s). ";
}else{
    print "Mailbox is empty.";
}
$conn->quit();   # close connection
#===========================================================================================
#ȫ��
if ($numMsg > 0) {
    my $msgList = $conn->list();
    foreach my $msg (keys(%$msgList)) {
        my $ref = $conn->top($msg,2);
        print (@$ref);
    }
}else{
    print "Mailbox is empty. ";
}
$conn->quit();
#===========================================================================================
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
#===========================================================================================
#my $time=(); 
#my $hour=(); 
#my $xxx=(); 
#my $h=(); 
#my $x=(); 
#my $g=-1;
#my $gn=();
#if ($g<=0) {
#	print "[Err]������ػ�ʱ��(��ʽ�� 20:13):"; 
#	my $g=<STDIN>; 
#	chomp($g); 
#	shut(); 
#}else{ 
#	shut(); 
#}
#sub shut { 
#	($h,$x) = split /:/, $g; 
#	while (){ 
#		open (T,"time /t|") or print "[Err]���ܻ�ȡϵͳʱ��!";
#		read(T,$time,25);   
#		($hour,$xxx) = split /:/, $time; 
#		if ($hour>=$h && $xxx>=$x){
#			system("shutdown /s /c ϵͳ���趨��$g�ر�,�뱣���˳�! /t 30");
#			exit; 
#		} 
#		close (T);
#		print "��û��$gn"; 
#		sleep(5);
#	} 
#}
#===========================================================================================





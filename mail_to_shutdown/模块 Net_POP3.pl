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
#登录
my $conn = Net::POP3->new($host) or die("ERROR: Unable to connect. ");   # initiate connection, default timeout = 120 sec
my $numMsg = $conn->login($user, $pass) or die("ERROR: Unable to login. ");   # login
#===========================================================================================
#邮件数
# display number of messages
if ($numMsg > 0) {
    print "Mailbox now has $numMsg message(s). ";
}else{
    print "Mailbox is empty.";
}
$conn->quit();   # close connection
#===========================================================================================
#全文
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
#===========================================================================================
#my $time=(); 
#my $hour=(); 
#my $xxx=(); 
#my $h=(); 
#my $x=(); 
#my $g=-1;
#my $gn=();
#if ($g<=0) {
#	print "[Err]请输入关机时间(格式如 20:13):"; 
#	my $g=<STDIN>; 
#	chomp($g); 
#	shut(); 
#}else{ 
#	shut(); 
#}
#sub shut { 
#	($h,$x) = split /:/, $g; 
#	while (){ 
#		open (T,"time /t|") or print "[Err]不能获取系统时间!";
#		read(T,$time,25);   
#		($hour,$xxx) = split /:/, $time; 
#		if ($hour>=$h && $xxx>=$x){
#			system("shutdown /s /c 系统被设定在$g关闭,请保存退出! /t 30");
#			exit; 
#		} 
#		close (T);
#		print "还没到$gn"; 
#		sleep(5);
#	} 
#}
#===========================================================================================





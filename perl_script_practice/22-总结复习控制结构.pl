#!/usr/bin/perl

#use v5.10.0;
use strict;
use warnings;

#============================
#forѭ�����Ʒ�
#============================
#for(���ʽ1;���ʽ2;���ʽ3){ѭ������}
#(1)���ʽ1����ʼ�����Ʊ���������������ֻ�ڵ�һ��ѭ��ʱִ�У������ɶ��ŷָ������������ֵ
#(2)���ʽ2��ÿ��ѭ��ʱ�Ƚϣ�Ϊ��ʱѭ��
#(3)���ʽ3��ÿ��ִ����ѭ�����ִ�У��ı���Ʊ�����ֵ��һ��Ϊ����
#(4)�������ʽ������ʡ�ԣ�������";"���뱣����for(;;)
#(5)��1��3���ʽ������ʹ��","ִ�ж�����

my $a=();
for ($a=0;$a<10;$a++){
	print "$a";
}print "\n";

#�����������
my $b=();
my @c=(1..10);
for ($b=0;$b<@c;$b++){
	print "$c[$b]";
}print "\n";

#============================
#foreachѭ�����Ʒ�
#============================
my @e=(1..10);
my $f=();
foreach $f (@e){   #@a���������е�Ԫ����������ø�$counter��Ȼ���$counter��ֵ��ӡ������ע��perl����ġ�=��ʵ���������ò��Ǹ�ֵ
	print "$f";
}print "\n";

my @g=(1..10);
my $h=();
foreach $h (@g){
	$h++;
}
print "@g";
print "\n";

#foreach����������ȡ����ϣ�еļ�ֵ��
my %nation=(
	"Dautschland"=>"Europe",
	"China"=>"Asia",
	"Germany"=>"Europe",
	"United States"=>"North Am"
);
my $country=();
foreach $country (keys %nation){   #ע��keys��values��������
	print "$country=>$nation{$country}\n";
}

my $kfc="999";
my @nation=("cccp","usa","china","england","france");
print "$kfc\n";   #���ؽ��999
foreach $kfc (@nation){   #foreach�еı�������ʱ����������֮ǰ�������֣���ѭ��������ָ�ԭֵ
	print $kfc;   #���ؽ��cccpusachinaenglandfrance
}print "\n";
print "$kfc\n";   #���ؽ��999

#============================
#if�������Ʒ�
#============================
#if��while�Ĳ�ͬ���ڣ�ifֻ��ִ��һ�Σ�while��һֱѭ��ֱ����������Ϊ��
my $i=3;
print "correct!" if ($i==3);   #��װ
print "\n";

#if
my $j=(); 
for ($j=0;$j<10;$j++){ 
	if ($j>5){
		print "haha";
	}
}print "\n";

#if-else
my $k=(); 
for ($k=0;$k<10;$k++){
	if ($k>5){
		print "haha";
	}else{
		print "lala";
	}
}print "\n";

#if-elsif-else 
my $l=(); 
for ($l=0;$l<10;$l++){ 
	if ($l>5){
		print "haha";
	}elsif ($l>3){
		print "lala";
	}else{
		print "gee!";
	}
}print "\n";

#============================
#unless�������Ʒ�
#============================
#unless��if�ķ���ʣ���if�÷���ȫһ�������൱�ڼ���һ��!(ȡ��)
my $m=();
for ($m=0;$m<10;$m++){
	print "$m" unless ($m>5);   #��װ
}print "\n";

my $n=();
for ($n=0;$n<10;$n++){
	print "$n" if !($n>5)   #��unlessЧ����һ����
}print "\n";

#============================
#while�������Ʒ�
#============================
#while��if�Ĳ�ͬ���ڣ�ifֻ��ִ��һ�Σ�while��һֱѭ��ֱ����������Ϊ��
my $o=0;
while (3>$o){
	print $o++;   #���ؽ��012
}print "\n";

my $p=0;
print $p++ while (3>$p);   #��װ
print "\n";   #���ؽ��012

#============================
#until�������Ʒ�
#============================
#����if��unlessһ����while���������Ϊ��ʱѭ��ִ��ѭ�����壬until���������Ϊ��ʱѭ��ִ��ѭ������
my $q=(); 
for ($q=0;$q<10;$q++){
	until ($q==1){
		print "$q" ;   #���ؽ��0234579������2345��until��ѭ�����
		$q++;
		last if ($q>5);   #ʹ��last�Ͳ����������˳�untilѭ��
	}
}print "\n";

#============================
#next��last��redo��continue
#============================
#next
#���������ı��ֲ������κβ�������������ʼ��һ��ѭ����
my $r=();
for ($r=0;$r<10;$r++){
	if ($r==5){
		next;
	}
	print "$r";   #���ؽ��01245678��ȱ��5
}print "\n";

#last
#�˳�ѭ��
my $s=();
for ($s=0;$s<10;$s++){ 
	last if($s==3);   #���ؽ��012
	print "$s"; 
}print "\n";

#redo
#��next��ͬ��redo��ִ��ʱֱ���ٴ�����ѭ�����壬����������������ƣ����û�в�����佫�������ѭ��
my $t=();
for ($t=0;$t<5;){
	$t++;
	redo if ($t==3);
	print "$t";   #���ؽ��1245
}print "\n";

#my $u=();
#for ($u=0;$u<5;$u++){
#	redo if ($u==4);   #���ڲ������û�з���ѭ�������У�������δ���������ѭ��
#	print "$u";
#}

#continue
#��ÿ��while������һȦ֮�������һ��continue�Ĳ��֣�Ȼ���������whileѭ��
my $v=0; 
while ($v<3){
	print "$v";
}continue{
	print "hello" if ($v++>1);   #���ؽ��012hello
}
 















































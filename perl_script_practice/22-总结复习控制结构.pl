#!/usr/bin/perl

#use v5.10.0;
use strict;
use warnings;

#============================
#for循环控制符
#============================
#for(表达式1;表达式2;表达式3){循环主体}
#(1)表达式1：初始化控制变量或其它变量，只在第一次循环时执行，可以由逗号分隔给多个变量赋值
#(2)表达式2：每次循环时比较，为真时循环
#(3)表达式3：每次执行完循环后才执行，改变控制变量的值，一般为自增
#(4)三个表达式都可以省略，但两个";"必须保留：for(;;)
#(5)第1、3表达式都可以使用","执行多个语句

my $a=();
for ($a=0;$a<10;$a++){
	print "$a";
}print "\n";

#对于数组而言
my $b=();
my @c=(1..10);
for ($b=0;$b<@c;$b++){
	print "$c[$b]";
}print "\n";

#============================
#foreach循环控制符
#============================
my @e=(1..10);
my $f=();
foreach $f (@e){   #@a数组中所有的元素先逐个引用给$counter，然后把$counter的值打印出来。注意perl里面的“=”实际上是引用不是赋值
	print "$f";
}print "\n";

my @g=(1..10);
my $h=();
foreach $h (@g){
	$h++;
}
print "@g";
print "\n";

#foreach可用于依次取出哈希中的键值对
my %nation=(
	"Dautschland"=>"Europe",
	"China"=>"Asia",
	"Germany"=>"Europe",
	"United States"=>"North Am"
);
my $country=();
foreach $country (keys %nation){   #注意keys和values两个函数
	print "$country=>$nation{$country}\n";
}

my $kfc="999";
my @nation=("cccp","usa","china","england","france");
print "$kfc\n";   #返回结果999
foreach $kfc (@nation){   #foreach中的变量是临时变量，如在之前有所出现，则循环结束后恢复原值
	print $kfc;   #返回结果cccpusachinaenglandfrance
}print "\n";
print "$kfc\n";   #返回结果999

#============================
#if条件控制符
#============================
#if和while的不同在于，if只会执行一次，while会一直循环直至条件不再为真
my $i=3;
print "correct!" if ($i==3);   #倒装
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
#unless条件控制符
#============================
#unless是if的反义词，和if用法完全一样，但相当于加上一个!(取非)
my $m=();
for ($m=0;$m<10;$m++){
	print "$m" unless ($m>5);   #倒装
}print "\n";

my $n=();
for ($n=0;$n<10;$n++){
	print "$n" if !($n>5)   #和unless效果是一样的
}print "\n";

#============================
#while条件控制符
#============================
#while和if的不同在于，if只会执行一次，while会一直循环直至条件不再为真
my $o=0;
while (3>$o){
	print $o++;   #返回结果012
}print "\n";

my $p=0;
print $p++ while (3>$p);   #倒装
print "\n";   #返回结果012

#============================
#until条件控制符
#============================
#正如if与unless一样，while在条件语句为真时循环执行循环主体，until在条件语句为假时循环执行循环主体
my $q=(); 
for ($q=0;$q<10;$q++){
	until ($q==1){
		print "$q" ;   #返回结果0234579，其中2345是until自循环结果
		$q++;
		last if ($q>5);   #使用last和步进语句配合退出until循环
	}
}print "\n";

#============================
#next、last、redo、continue
#============================
#next
#满足条件的本轮不进行任何操作，跳过并开始下一轮循环，
my $r=();
for ($r=0;$r<10;$r++){
	if ($r==5){
		next;
	}
	print "$r";   #返回结果01245678，缺少5
}print "\n";

#last
#退出循环
my $s=();
for ($s=0;$s<10;$s++){ 
	last if($s==3);   #返回结果012
	print "$s"; 
}print "\n";

#redo
#与next不同，redo在执行时直接再次运行循环主体，并不受条件语句限制，因此没有步进语句将会进入死循环
my $t=();
for ($t=0;$t<5;){
	$t++;
	redo if ($t==3);
	print "$t";   #返回结果1245
}print "\n";

#my $u=();
#for ($u=0;$u<5;$u++){
#	redo if ($u==4);   #由于步进语句没有放在循环主体中，所以这段代码会进入死循环
#	print "$u";
#}

#continue
#在每个while运行了一圈之后会运行一遍continue的部分，然后继续进行while循环
my $v=0; 
while ($v<3){
	print "$v";
}continue{
	print "hello" if ($v++>1);   #返回结果012hello
}
 















































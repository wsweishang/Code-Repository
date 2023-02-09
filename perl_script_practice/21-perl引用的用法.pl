#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

##==================================
##perl引用的用法-极其重要-坚决拿下
##==================================
##引用就是指针
##Perl引用是一个标量类型，可以指向变量、数组、哈希表（也叫关联数组）甚至子程序
##Perl引用可以应用在程序的任何地方
##匿名引用较之引用更为常用
#
##=========================
##使用ref函数判断变量类型
##=========================
#my $var = 10;
#my $r1 = \$var;
#print "r 的引用类型 : ", ref($r1), "\n";
#my @var = (1, 2, 3);
#my $r2 = \@var;
#print "r 的引用类型 : ", ref($r2), "\n";
#my %var = ('key1' => 10, 'key2' => 20);
#my $r3 = \%var;
#print "r 的引用类型 : ", ref($r3), "\n";
#
##======================
##字符串引用
##======================
#my $value="ATGCN";
#my $valueRef=\$value;   #字符串引用的方式：\$xxx
#print "$value and $valueRef\n";
#my $derefRalueRef=${$valueRef};   #字符串解引用的方式：${$xxx}
#print "$value and $valueRef and $derefRalueRef\n";
#
##======================
##匿名引用字符串
##======================
#my $value1=\"ATGCN";   #在字符串中，匿名字符串的引用使用\"string"定义
#print $value1 . "and ${$value1}\n";   #使用$@%对字符串、数组、哈希依次解引用
#
##======================
##数组引用
##======================
my @sequences=("ATTTAC", "AACCGCTT","AACCTT");
my $arrayRef=\@sequences;   #数组引用的方式：\@xxx
my @deRefarray=@{$arrayRef};   #数组解引用的方式：@{$xxx}
#${$arrayRef}[0];
print $arrayRef."\n";
print "@deRefarray.\n";
print ref($arrayRef)."\n";
print  $arrayRef->[0],$arrayRef->[1],$arrayRef->[2],"\n";   #数组取出元素用指针：$xxx->[nnn],$xxx->[nnn]

##======================
##匿名引用数组
##======================
#my $sequences=["ATTTAC","AACCGCTT","AACCTT"];   #匿名数组的引用使用[]定义
#print $sequences."\n";
#print ref($sequences)."\n";   #ref函数
#print  $sequences->[0],$sequences->[1],$sequences->[2],"\n";
#$sequences=[["ATTTAC", "AACCGCTT","AACCTT"],["ATTTAC", "AACCGCTT","AACCTT"],["ATTTAC", "AACCGCTT","AACCTT"]];   #匿名引用多个数组，形成数据矩阵
#print $sequences."\n";
#print ref($sequences)."\n";
#print  $sequences->[0],$sequences->[1],$sequences->[2],"\n";   #解引用只有一层是不行的
#print  $sequences->[0][1],$sequences->[1]->[0],$sequences->[2],"\n";   #得像这样有两层才行
#
##======================
##哈希引用
##======================
use Data::Dumper;
my %myHash=('ID123'=>"gff",
			'ID124'=>"gff1",
			'ID125'=>"gff3",
	);
my $refHash=\%myHash;   #
print Dumper(\%myHash)."\n";   #
print $refHash."\n";
foreach my $k(keys %$refHash){   #解引用的简化写法，省略了花括号和瘦键头
	print "key:$k\t${$refHash}{$k}\n";
}
print "other\n";
foreach my $k(keys %$refHash){   #解引用的简化写法，省略了花括号和瘦键头
	print "key:$k\t$$refHash{$k}\n";
}
print "other\n";
foreach my $k(keys %{$refHash}){   #解引用的完整写法，推荐
	print "key:$k\t$refHash->{$k}\n";
}

##======================
##匿名引用哈希
##======================
#my $myHash={'ID123'=>"gff",
#			 'ID124'=>"gff1",
#			 'ID125'=>"gff3"};   #在哈希中匿名哈希的引用使用{}定义，注意不是\{}
#say %{$myHash};   #解引用是一样的
#print $myHash->{ID123}."\n";   #哈希取出键值对用指针
#foreach my $q(keys %$myHash){
#	say "key:$q\t$myHash->{$q}";   #匿名哈希取出键值对
#}
#======================
#实例
#======================
#use Data::Dumper;
#
#open (IN, "<E:/学习/杂项/Perl/Arabidopsis_thaliana.TAIR10.37.gff3") or die "$!";
#open (OUT, ">D:/1.txt") or die "$!";
#my %geneInfo=();
#while (my $line=<IN>){
#	chomp $line;
#	next if ($line=~/^#/);
#	my @tmp=split(/\t/,$line);
#	if ($tmp[2] eq "gene"){	
#		my ($geneID)=($tmp[-1]=~/ID=([^;]+)/);
#		$geneInfo{$geneID}{'location'}=[$tmp[0],$tmp[3],$tmp[4]];
#		$geneInfo{$geneID}{'transcripts'}=[];
#	}
#	if ($tmp[2] eq "mRNA"){
#		my ($mRNAID,$ParentID)=($tmp[8]=~/ID=([^;]+).*Parent=([^;]+)/);
#		push @{$geneInfo{$ParentID}{'transcripts'}}, {"mRNAID"=>$mRNAID,"chr"=>$tmp[0], "start"=>$tmp[3],"end"=>$tmp[3]};
#	}
#}
#print OUT Dumper(\%geneInfo);
#foreach my $id(keys %geneInfo){
#	print "\n";
#	print "@{$geneInfo{$id}{location}}\n";
#	print "@{$geneInfo{$id}{transcripts}}\n";
#	if ( @{$geneInfo{$id}{transcripts}} >0){
#		print "${$geneInfo{$id}{transcripts}}[0]->{mRNAID}\n";
#	}
#}
#close (IN);
#close (OUT);





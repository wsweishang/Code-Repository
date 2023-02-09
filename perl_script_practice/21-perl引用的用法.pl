#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

##==================================
##perl���õ��÷�-������Ҫ-�������
##==================================
##���þ���ָ��
##Perl������һ���������ͣ�����ָ����������顢��ϣ��Ҳ�й������飩�����ӳ���
##Perl���ÿ���Ӧ���ڳ�����κεط�
##�������ý�֮���ø�Ϊ����
#
##=========================
##ʹ��ref�����жϱ�������
##=========================
#my $var = 10;
#my $r1 = \$var;
#print "r ���������� : ", ref($r1), "\n";
#my @var = (1, 2, 3);
#my $r2 = \@var;
#print "r ���������� : ", ref($r2), "\n";
#my %var = ('key1' => 10, 'key2' => 20);
#my $r3 = \%var;
#print "r ���������� : ", ref($r3), "\n";
#
##======================
##�ַ�������
##======================
#my $value="ATGCN";
#my $valueRef=\$value;   #�ַ������õķ�ʽ��\$xxx
#print "$value and $valueRef\n";
#my $derefRalueRef=${$valueRef};   #�ַ��������õķ�ʽ��${$xxx}
#print "$value and $valueRef and $derefRalueRef\n";
#
##======================
##���������ַ���
##======================
#my $value1=\"ATGCN";   #���ַ����У������ַ���������ʹ��\"string"����
#print $value1 . "and ${$value1}\n";   #ʹ��$@%���ַ��������顢��ϣ���ν�����
#
##======================
##��������
##======================
my @sequences=("ATTTAC", "AACCGCTT","AACCTT");
my $arrayRef=\@sequences;   #�������õķ�ʽ��\@xxx
my @deRefarray=@{$arrayRef};   #��������õķ�ʽ��@{$xxx}
#${$arrayRef}[0];
print $arrayRef."\n";
print "@deRefarray.\n";
print ref($arrayRef)."\n";
print  $arrayRef->[0],$arrayRef->[1],$arrayRef->[2],"\n";   #����ȡ��Ԫ����ָ�룺$xxx->[nnn],$xxx->[nnn]

##======================
##������������
##======================
#my $sequences=["ATTTAC","AACCGCTT","AACCTT"];   #�������������ʹ��[]����
#print $sequences."\n";
#print ref($sequences)."\n";   #ref����
#print  $sequences->[0],$sequences->[1],$sequences->[2],"\n";
#$sequences=[["ATTTAC", "AACCGCTT","AACCTT"],["ATTTAC", "AACCGCTT","AACCTT"],["ATTTAC", "AACCGCTT","AACCTT"]];   #�������ö�����飬�γ����ݾ���
#print $sequences."\n";
#print ref($sequences)."\n";
#print  $sequences->[0],$sequences->[1],$sequences->[2],"\n";   #������ֻ��һ���ǲ��е�
#print  $sequences->[0][1],$sequences->[1]->[0],$sequences->[2],"\n";   #�����������������
#
##======================
##��ϣ����
##======================
use Data::Dumper;
my %myHash=('ID123'=>"gff",
			'ID124'=>"gff1",
			'ID125'=>"gff3",
	);
my $refHash=\%myHash;   #
print Dumper(\%myHash)."\n";   #
print $refHash."\n";
foreach my $k(keys %$refHash){   #�����õļ�д����ʡ���˻����ź��ݼ�ͷ
	print "key:$k\t${$refHash}{$k}\n";
}
print "other\n";
foreach my $k(keys %$refHash){   #�����õļ�д����ʡ���˻����ź��ݼ�ͷ
	print "key:$k\t$$refHash{$k}\n";
}
print "other\n";
foreach my $k(keys %{$refHash}){   #�����õ�����д�����Ƽ�
	print "key:$k\t$refHash->{$k}\n";
}

##======================
##�������ù�ϣ
##======================
#my $myHash={'ID123'=>"gff",
#			 'ID124'=>"gff1",
#			 'ID125'=>"gff3"};   #�ڹ�ϣ��������ϣ������ʹ��{}���壬ע�ⲻ��\{}
#say %{$myHash};   #��������һ����
#print $myHash->{ID123}."\n";   #��ϣȡ����ֵ����ָ��
#foreach my $q(keys %$myHash){
#	say "key:$q\t$myHash->{$q}";   #������ϣȡ����ֵ��
#}
#======================
#ʵ��
#======================
#use Data::Dumper;
#
#open (IN, "<E:/ѧϰ/����/Perl/Arabidopsis_thaliana.TAIR10.37.gff3") or die "$!";
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





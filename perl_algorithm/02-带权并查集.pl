#!/usr/bin/perl

use strict;
use warnings;

#==============================================
#��Ȩ���鼯
#==============================================

my @p=();
my @s=();
my $ans=0;
foreach my $data(<DATA>){
	chomp $data;
	my @data=split (/\t/,$data);
	if (!$data[2]){
		my ($m,$n)=@data[0,1];
		for (my $i=0;$i<=$m;$i++){
    		$p[$i]=$i;
    		$s[$i]=0;
    	}
		next;
	}
	my ($a,$b,$c)=@data[0..2];
	&merge($a-1,$b,$c);
}
print "error number: $ans\n";

sub getf{   #��ʱgetf�����в������񣬻��и��¾�������
	my $x=$_[0];
	if ($x==$p[$x]){
		return $x;
	}else {
		$p[$x]=&getf($p[$x]);
		$s[$x]+=$s[$p[$x]];   #��¼�����ڵ�ľ��룬һ��Ҫ��һ��˼�룬���ڵ���һ�������һ���˵������һ�����䣬��������䱻�ϲ�����������
		return $p[$x];
	}
}

sub merge{
	my ($a,$b,$num)=@_[0..2];
	my $x=&getf($a);
	my $y=&getf($b);
	if ($x==$y){
		$ans++ if ($s[$b]!=$s[$a]+$num);
	}else {
		$p[$y]=$x;
		$s[$y]=$s[$a]+$num-$s[$b];   #y��x�ľ������a��x�ľ���+b��a�ľ���-b��y�ľ���
	}
}

__DATA__
10	5
1	10	100
1	2	32
3	3	-1	0
4	6	41
7	10	28
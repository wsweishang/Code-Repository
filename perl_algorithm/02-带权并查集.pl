#!/usr/bin/perl

use strict;
use warnings;

#==============================================
#带权并查集
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

sub getf{   #此时getf不单有查找任务，还有更新距离任务
	my $x=$_[0];
	if ($x==$p[$x]){
		return $x;
	}else {
		$p[$x]=&getf($p[$x]);
		$s[$x]+=$s[$p[$x]];   #记录到根节点的距离，一定要有一个思想，根节点是一个区间的一个端点而不是一个区间，输入的区间被合并成了两个点
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
		$s[$y]=$s[$a]+$num-$s[$b];   #y到x的距离等于a到x的距离+b到a的距离-b到y的距离
	}
}

__DATA__
10	5
1	10	100
1	2	32
3	3	-1	0
4	6	41
7	10	28
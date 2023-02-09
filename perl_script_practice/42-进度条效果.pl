#!/usr/bin/perl

use strict;
use warnings;

#Perl的几种进度条显示方法：
#1.用点来表示进度，windows的经典模式
#$|=1;   #不经过缓存立即输出
#my $max=10;
#for (1..$max){
#	print ".";
#	print " Complete!" if ($_==$max);
#	sleep (1);
#}

#2.用斜杠在转动，有点程序的样子
#local $|=1;
#my @progress_symbol=('-','\\','|','/');
#my $n=0;
#for (my $i=1;$i<=3000;$i++){
#	print "\r $progress_symbol[$n] $i";
#	$n=($n>=3)?0:$n+1;   #条件运算符：当$n大于等于3的时候，$n为0，否则$n+1
#	select (undef, undef, undef, 0.1);
#}
#local $| = 0;

#3.时钟的显示方式
my $now = ();
local $| = 1;
while (1){
	&gettime;
	print "\r $now";
	sleep(1);
}
local $| = 0;
exit;

sub gettime{
	my ($sec,$min,$hour,$day,$mon,$year,$weekday,$yeardate,$savinglightday) = (localtime(time));
	$sec = ($sec < 10)? "0$sec":$sec;
	$min = ($min < 10)? "0$min":$min;
	$hour = ($hour < 10)? "0$hour":$hour;
	$day = ($day < 10)? "0$day":$day;
	$mon = ($mon < 9)? "0".($mon+1):($mon+1);
	$year += 1900;
	$now = "$year.$mon.$day $hour:$min:$sec";
}

#4.有进度条显示，最帅的了
#my $n = 100;
#for (my $i=1;$i<=$n;$i++){
#	proc_bar($i,$n);
#	select(undef, undef, undef, 0.2);
#}
#
#sub proc_bar{
#	local $| = 1;
#	my $i = $_[0] || return 0;
#	my $n = $_[1] || return 0;
#	print "\r [ ".("=" x int(($i/$n)*50)).">".(" " x (50 - int(($i/$n)*50)))." ] ";
#	printf ("%2.1f %%",$i/$n*100);
#	local $| = 0;
#}


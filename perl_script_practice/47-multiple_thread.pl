#!/usr/bin/perl

use strict;
use warnings;
use threads;
use threads::shared;

#my @ips = ("221.141.1.222", "89.46.101.122", "199.200.120.37");
#
#my @threads = ();
## �����̲߳�push�������С���һ��������һ���ӳ�������֣�����Ĳ��������뵽���ӳ�����������ݡ�
#foreach (@ips) {
#    push (@threads, threads -> create(\&ping, $_));
#}
#
## �ӳ���join�����̣߳�ȡ�÷���ֵ��
#foreach (@threads) {
#    $_ -> join();
#}
#
## �ӳ��򣬶�ip��ַping5�Σ��õ���ƽ��ֵ��
#sub ping {
#    $_ = shift;
#    my $ping_log = `ping -c 5 $_`;
#    my @ping_log = split /\n/, $ping_log;
#    my $time = 0;
#    foreach (@ping_log) {
#        $time += $1 if /time=(.*) ms/;
#    }
#    my $avg_time = $time / 5;
#    $time = "na" if $time == 0;
#    print "$_\t$avg_time\n";
#}


print "Starting main program\n";
 
my @threads = ();
for ( my $count = 1; $count <= 10; $count++) {
	my $t = threads -> new (\&sub1, $count, "hello, word");
	push (@threads, $t);
}
foreach (@threads) {
	my $num = $_ -> join;
	print "done with $num\n";
}
print "End of main program\n";
 
sub sub1 {
	my ($num, $str) = @_;
	print "started thread $num, $str\n";
	sleep $num;
	print "done with thread $num\n";
	return $num . " haha...";
}











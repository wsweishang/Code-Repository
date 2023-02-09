#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#======================================
#综合练习：利用hash统计数据及计数
#======================================

open (IN,"<D:/data.txt") || die "$!";
open (OUT,">D:/data_out.txt") || die "$!";

my %Data_count=(
	"0.5-5"=>0,
	"5-100"=>0,
	"100+"=>0
);

print "Please input the colume:";
my $count=<STDIN>-1;

while (my $Data1=<IN>){
	chomp $Data1;
	my @Data2=split(/\t/,$Data1);
	if ($Data2[$count]>=0.5 and $Data2[$count]<5){
		$Data_count{"0.5-5"}++;
	}
	if ($Data2[$count]>=5 and $Data2[$count]<100){
		$Data_count{"5-100"}++;
	}
	if ($Data2[$count]>=100){
		$Data_count{"100+"}++
	}	
}
close (IN);
while (($a,$b)=each %Data_count){
	say "$a => $b";
	say OUT "$a => $b";
}
close (OUT);


#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#=============================
#perl命令行参数传递-@ARGV
#=============================

die "perl $0 <IN> <OUT>" unless(@ARGV==2);

open (IN,"<$ARGV[0]") || die "$!";
open (OUT,">$ARGV[1]") || die "$!";

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








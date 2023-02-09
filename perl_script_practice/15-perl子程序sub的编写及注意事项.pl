#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#===============================
#perl子程序sub的编写及注意事项
#===============================

#传递多个变量到子程序中、指针
sub hello{
	say "@_";
	my ($name1,$name2)=@_;
	say "hello $name1->[0]";
	say "hello $name2->[1]";
}

my @names1=("lucy","tom");
my @names2=("lucy1","tom1");
&hello (\@names1,\@names2);

#求和
sub sumNum{
	my @nums=@_;
	my $sum=0;
	for my $n(@nums){
		say $n;
		$sum=$sum+$n;
	}
	return $sum;	#注意return函数
}
my $all=&sumNum(1..100);
say "sum is $all";

#取出哈希键值
sub get_hash{
	my (%hash)=@_;
	for my $key(keys %hash){
		say "$key => $hash{$key}";
	}
}
my %names=(
	"name1"=>"weihshang",
	"name2"=>"liyinggang"
);
&get_hash(%names);



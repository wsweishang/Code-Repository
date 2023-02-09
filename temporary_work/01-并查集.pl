#!/usr/bin/perl

use strict;
use warnings;

#==================================
#union find set：并查集
#==================================
my %hash = ();
while (my $data = <DATA>) {
	chomp $data;
	my @data = split (/\t/, $data);
	$hash{$data[0]} = $data[0] unless (exists $hash{$data[0]});
	$hash{$data[1]} = $data[1] unless (exists $hash{$data[1]});
	&merge($data[0], $data[1]);
}
close (DATA);

sub getf{   #查找与路径压缩
	my $getf = $_[0];
	if ($hash{$getf} eq $getf) {
		return $getf;
	} else {
		$hash{$getf} = &getf($hash{$getf});
		return $hash{$getf};
	}
}

sub merge{   #合并分支
	my ($left, $right) = @_[0, 1];
	$left = &getf($left);
	$right = &getf($right);
	if ($left ne $right) {
		$hash{$right} = $left;
	}
	return;
}

my $i = 0;
while (my ($key, $value) = each %hash) {
	print "$key => $value\n";
	$i++ if ($value eq $key);
}
print "${i} groups\n";

__DATA__
A	B
B	C
C	D
D	E
E	F
F	Q
G	R
H	S
I	H
J	I
K	J
L	K
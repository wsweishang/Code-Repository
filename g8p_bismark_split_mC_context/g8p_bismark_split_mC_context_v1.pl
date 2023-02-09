#!/usr/bin/perl

use strict;
use warnings;

my $cpg_txt_path = $ARGV[0];
my $cov_path = $ARGV[1];
my $out_path = $ARGV[2];

my %cpg_txt_data = ();
open (INCPG,"<${cpg_txt_path}") or die "$!";
while (<INCPG>) {
	next if ($. == 1);
	chomp (my $cpg_txt_data = $_);
	my @cpg_txt_data = split (/\t/,$cpg_txt_data);
	$cpg_txt_data{$cpg_txt_data[2]}{$cpg_txt_data[3]}=1;
}
close (INCPG);

my $i=0;
my $j=0;
my $m=0;
open (INCOV,"<${cov_path}") or die "$!";
open (OUT,">$out_path") or die "$!";
while (<INCOV>){
	chomp (my $cov_path = $_);
	$j++;
	my @cov_path = split (/\t/,$cov_path);
	my $all_count_read = $cov_path[4] + $cov_path[5];
	if (exists $cpg_txt_data{$cov_path[0]}{$cov_path[1]}){
		print OUT "$cov_path[0]\t$cov_path[1]\t$all_count_read\t$cov_path[4]\n";
		$m++;
	}else {
		$i++;
	}
}
close (INCOV);
close (OUT);

my $result1 = $m/$j;
my $result2 = $i/$j;
print "$result1\t$result2\n";




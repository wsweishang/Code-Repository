#!/usr/bin/perl

use strict;
use warnings;

#(1) VS (1)

#sub SUM{
#	my @all=@_;
#	$all[12] += $all[11];
#	$all[13] += $all[12];
#	$all[14] += $all[13];
#	$all[16] += $all[14];
#	$all[17] += $all[16];
#	$all[18] += $all[17];
#	return $all[18];
#}
mkdir "G:/result";
my %compared_data=();
my @files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";

foreach my $file_a(@files){
	open (INCOMPARED,"<$file_a");
	my @compared_file=<INCOMPARED>;
	foreach my $compared_data(@compared_file){
		chomp $compared_data;
		next if ($compared_data=~/^#.*/);
		my @compared_content=split(/\t/,$compared_data);
		$compared_data{$compared_content[1]}=1;
	}
	foreach my $file_b(@files){
		next if ($file_a eq $file_b);
		open (INCOMPARE,"<$file_b");
		my @file_a=split (/\//,$file_a);
		my @file_b=split(/\//,$file_b);
		my $a=pop @file_a;
		my $b=pop @file_b;
		$a=substr($a,0,2);
		$b=substr($b,0,2);
		open (OUT,">G:/result/$b - $a.txt");
		my @compare_file=<INCOMPARE>;
		foreach my $compare_data(@compare_file){
			chomp $compare_data;
			next if ($compare_data=~/^#.*/);
			my @compare_content=split(/\t/,$compare_data);
			unless (exists $compared_data{$compare_content[1]}){
#				my $result=&SUM(@compare_content);
#				unless ($result==0){
					print OUT "$compare_data\n";
#				}
			}
		}
	}
}
close (INCOMPARED);
close (OUT);




#&USAGE if ($ARGV[0]=~/\?help/);
#
#my @files=glob "$ARGV[0]/*.txt";
#print "比较种群：\n";
#my $population_compare=<STDIN>;
#my @population_compare=split(/\s/,$population_compare);
#print "被比较种群：\n";
#my $population_compared=<STDIN>;
#my @population_compared=split(/\s/,$population_compared);
#foreach my $file(@files){
#}

#sub USAGE{
#	my $usage=<<"usage";
#MANUAL
#OPTIONS:
#	(NP, IN) VS (AX, TJ, YJ, WZ, ZJ)
#	-ARGV[0]
#	-ARGV[1]
#	将NP、IN、AX、TJ、YJ、WZ、ZJ放入一个文件夹中
#	···
#usage
#	print $usage;
#	exit;
#}


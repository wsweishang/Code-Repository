#!/usr/bin/perl

use strict;
use warnings;
use Cwd 'abs_path';
use File::Basename;
use Getopt::Long;
use Data::Dumper;
use FindBin qw($Bin);

# Global variable
my ($help, $outDir);
# Get Parameter
GetOptions(
	"h|help" => \$help, 
	"outDir=s" => \$outDir,
);
my $tmpDir = `pwd`;
chomp $tmpDir;
$outDir ||= "$tmpDir";
# Guide for program
my $guide_separator = "#" x 80;
my $program = basename(abs_path($0));
$program =~ s/\.pl//;
my $guide=<<INFO;
VER
	AUTHOR: xuxiangyang(xy_xu\@foxmail.com)
	NAME: $program
	PATH: $0
	VERSION: v1.0   2020-01-21
NOTE
USAGE
	$program <options> *.bam|*.sam 
	$guide_separator Basic $guide_separator
	--help				print help information
	--outDir <s>		script out Dir, default "$outDir"
INFO
die $guide if (@ARGV == 0 || defined $help);
# Main
my $total_read;
my $unmapped_read;
my $dup_read;
my $lowq_read;
my $effect_read;
my %result;
if ($ARGV[0] =~ m/bam$/i) {
	open IN, "samtools view $ARGV[0] | " or die $!; 
} else {
	open IN, $ARGV[0] or die $!;
}
while (<IN>) {
	$total_read++;
	chomp;
	my @arr = split /\t/;
	# 过滤未必对上的reads
	if ($arr[1] & 4) {
		$unmapped_read++;
		next;
	}
	# 过滤非初级比对的reads
	next if ($arr[1] & 256);
	# 过滤dup reads
	if ($arr[1] & 1024) {
		$dup_read++;
		next;
	}
	# 过滤supplementary alignment
	next if ($arr[1] & 2048);
	# 过滤低质量的reads
	if ($arr[4] < 30) {
		$lowq_read++;
		next;
	}
	if ($arr[5] =~ m/36M/) {
		$effect_read++;
		my $pos = $arr[3];
		#print "$arr[9]\n";
		while ($arr[9] =~ /(\w*?)((?:cg){2,})/gi) {
			#print "$1\n";
			#print "$2\n";
			my $s = $pos + length($1);
			my $e = $pos + length($1) + length($2) - 1;
			$pos += length($1) + length($2);
			#print "$arr[2]\t$s\t$e\t$2\t$2\n"; 
			$result{$arr[2]}{$s}{$e}{$2}++;
		}
	}
}
close IN;
my $unmapped_ratio = sprintf("%.2f", $unmapped_read/$total_read*100);
my $dup_ratio = sprintf("%.2f", $dup_read/$total_read*100); 
my $lowq_ratio = sprintf("%.2f", $lowq_read/$total_read*100);
my $effect_ratio = sprintf("%.2f", $effect_read/$total_read*100);
print STDERR "unmapped_ratio: $unmapped_ratio%\n";
print STDERR "dup_ratio: $dup_ratio%\n";
print STDERR "lowq_ratio: $lowq_ratio%\n";
print STDERR "effect_ratio: $effect_ratio%\n";
foreach my $chr (sort {$a cmp $b} keys %result) {
	foreach my $start (sort {$a <=> $b} keys %{$result{$chr}}) {
		foreach my $end (sort {$a <=> $b} keys %{$result{$chr}{$start}}) {
			foreach my $genotype (sort {$a cmp $b} keys %{$result{$chr}{$start}{$end}}) {
				my $count = $result{$chr}{$start}{$end}{$genotype};
				print "$chr\t$start\t$end\t$genotype\t$genotype\t$count\n";
			}
		}
	}
}









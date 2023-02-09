#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use File::Basename;

#============================================
#合并文件
#============================================

my %data=();
my @files = glob "*.txt";
foreach my $file(@files){
	my $file_name = basename ($file);
	open my $fh, '<', $file or die $!;   #注意open的这种用法
	while (<$fh>){
		next if /^\s*$/;
		next if /^gene_number/;
		chomp;
		my ($num, $pos, $snp) = split;
		$data{$num}{$pos}{$file_name} = $snp;   #注意哈希的这种用法           
	}
	close $fh;
}

print "gene_number\tposition";
foreach my $file(sort @files){
	my $file_name = basename ($file);
	print "\t$file_name";
}
print "\n";

foreach my $num(sort keys %data){   #取出num
	foreach my $pos(sort keys %{$data{$num}}){   #取出pos
		print "$num\t$pos";
		foreach my $file(sort @files){
			my $file_name = basename ($file);
			if (exists $data{$num}{$pos}{$file_name}){
				print "\t$data{$num}{$pos}{$file_name}";
			}else{
				print "\tNA";
			}
		}
		print "\n";
	}
}


#============================================
#交叉合并文件
#============================================

my $name_1="G:/1.txt";
my $name_2="G:/2.txt";   #得到命令行参数

#open the ori perlterm script
open (TXT_1,"<$name_1");
open (TXT_2,"<$name_2");   #得到两个文件句柄
my @a=<TXT_1>;
my @b=<TXT_2>;   #得到两个文件内容
my $line_b=@b;   #b.txt文件内容传递

my $count_line=0;   #初始化文件行数
open my $newfile,">","G:/c.txt";   #创建升成的新文件和句柄
foreach (@a){   #循环开始交叉合并
	chomp;
	say $newfile $_;
	say $_;
	if ($count_line <= $line_b){   #利用了if只会执行一次的特性
		print $newfile $b[$count_line];
		print $b[$count_line];
		$count_line+=1;
	}
}
close ($newfile) or warn "can not close the file";   #关闭句柄



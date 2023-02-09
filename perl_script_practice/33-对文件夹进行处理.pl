#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#perl对文件夹处理
#用perl批量处理文件夹下所有文件 opendir()获取目录权柄；readdir()读取目录下文件
#指定一个目录 opendir ( DIR, $dirname ) || die...
#用perl批量处理文件夹下所有文件
#opendir()获取目录权柄；readdir()读取目录下文件
my $dirname1 = "/tmp";         #指定一个目录
my $filename=();
opendir (DIR,$dirname1 ) || die "Error in opening dir \$dirname1";
while(($filename = readdir(DIR))){
	print("$filename");       #循环输出该目录下的文件
}
closedir (DIR);
#例：把每个文件复制一次
my %h=();
my $dirname="/home/bmk/";
opendir (DIR,$dirname) || die "Error in opening dir \$dirname";
while (($filename=readdir(DIR))){
	open (FILE,"/home/bmk/".$filename)|| die "can not open the file \$filename";
	open (OUT,">/home/bmk/$filename.bak")|| die "can not open the \$filename.bakn";
	while (<FILE>){
		print OUT "$_";
	}
}
closedir (DIR);


#readdir函数从一个用 opendir 打开的目录句柄读取目录记录也就是文件名。用法如下：
readdir (DIRHANDLE);
closedir (DIRHANDLE);
#在标量环境中，readdir函数返回下一个目录记录，否则，它返回undef。在列表环境中，它返回在该目录中所有剩下的记录，如果剩下没有记录了，那么这个返回可能是一个空列表。比如：
opendir (THISDIR, ".") or die "serious dainbramage: $!";
my @allfiles = readdir (THISDIR);
closedir (THISDIR);
print "@allfiles\n";
#上面的代码在一行里打印出当前目录的所有文件。如果你想避免“.”和“..”记录，使用下面其中的一条：
@allfiles = grep {$_ ne '.' and $_ ne '..'} readdir THISDIR;
@allfiles = grep {not /^[.][.]?\z/} readdir THISDIR;
@allfiles = grep {not /^\.{1,2}\z/} readdir THISDIR;
@allfiles = grep !/^\.\.?\z/, readdir THISDIR;
#为了避免所有 .* 文件：
@allfiles = grep !/^\./, readdir THISDIR;
#只拿出文本文件：
my @textfiles = grep -T, readdir THISDIR;
#不过我们再看看最后一个例子，因为如果readdir的结果不在当前目录里，那么我们需要在它的结果上把目录部分粘回去——像这样：
my $path=();
opendir (THATDIR, $path) or die "can't opendir $path: $!";
my @dotfile = grep { /^\./ && -f } map { "$path/$_" } readdir(THATDIR);
closedir (THATDIR);













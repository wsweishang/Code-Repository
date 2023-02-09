#!/usr/bin/perl

use strict;
use warnings;

#有太多次写完一个perl程序，需要另外新建一个文件来测试，每次觉得很繁琐，但又不得不这么做。没想到原来perl已经提供了解决方案，这就是DATA
#这个用法太方便太perl了，以后再也不需要使用新建文件的笨方法了
#<IN>可以从打开的句柄IN中获得数据，<STDIN>可以从标准输入接收数据，类似地，<DATA> 文件句柄可以直接从执行它的脚本中获取数据，而不是从命令行或者从另一个文件里获取
#<DATA> 所读取的数据保存在每个脚本末尾的特殊常量__DATA__之后，同时这个常量也标志着脚本的逻辑结束

#英文解释：
#A Virtual File In Perl
#It has been occurred a lot of times that one has to test a code using data from a file.
#It can be anything like checking for a pattern in a file to taking some input.
#If you want to check the code without opening the file and reading it.
#One can use the __DATA__ marker provided by perl as a pseudo-datafile.
#Steps to follow:
#1) At the end of the code use __DATA__ marker and copy paste or write the contents of the file you wish to test exactly from the next line of _DATA_.
#2) Use while (){ -- your code here -- }.
#Output of the above program will be “there”.

while (<DATA>){
	chomp $_;
	print $_;
}

while (<DATA>){
	chomp $_;
	print "Found" if $_ =~ /(t\w+)/;
	print "$1\n";
}
#注意：脚本中有两个while(<DATA>)将只有前一个起作用，因为前一个已经读到了文件结尾
__DATA__
hello there how r u
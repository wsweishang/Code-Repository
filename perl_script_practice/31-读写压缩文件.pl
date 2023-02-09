#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

#perl读写gz压缩文件
#perl 输入输出文件通常为文本文件，而如果是压缩文件也是可以处理的。与普通文件读写类似，都要获取文件句柄，只是稍有变化。
#输入文件句柄：
open (IN,"gzip -dc infile.gz|") or die "$!";
close (IN);
#输出文件句柄：
open (OUT,"| gzip > outfile.gz") or die "$!";
close (OUT);









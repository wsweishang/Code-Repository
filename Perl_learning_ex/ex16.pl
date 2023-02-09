#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

open (INFILE,">d:/test.txt");   #注意是左反斜杠
#">"表示清空文件原有内容，重新写入；">>"代表在文件原有内容基础上追加新内容
print INFILE "test\n";
print INFILE "123\n";
close "INFILE";

my $file;
open (OUTFILE, "d:/test.txt");
while ($file = <OUTFILE>){   #通过while循环打印文件内容，直到文件结束
	say "$file";
}
close (OUTFILE);

#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#======================================
#perl调用系统命令system
#======================================

my $dir="/home/manager/perl_script/";   #在perl中调用系统命令时，建议使用绝对路径，并将过长的路径存入一个变量中，以内插的方式使用，方便查看
my @files=glob("$dir/fasta_files/*fasta");   #*fasta表示以fasta为后缀的文件
my @files1=glob("$dir/fasta_files/1111111*");   #1111111*表示以1111111开头的文件
for my $i (@files){
	print "$i\n" or die "$!";
	print "blastall -i $i -d $dir/blastdb/ref.fa -e 1e-10 -p blastp -m 8 -o $i.out\n" or die "$!";
	system("blastall -i $i -d $dir/blastdb/ref.fa -e 1e-10 -p blastp -m 8 -o $i.out") or die "$!";   #system函数调用系统命令，会将字符串导入命令行并运行
	`blastall -i $i -d $dir/blastdb/ref.fa -e 1e-10 -p blastp -m 8 -o $i.out` or die "$!";   #system函数可以用一对``符号替代，不过不建议这样使用
	system("perl 17.pl");   #命令行中的perl 17.pl运行指令本质也是系统命令，因此system函数可以在perl中调用另一个perl程序
	my $err=system("blastall -i $i -d $dir/blastdb/ref.fa -e 1e-10 -p blastp -m 8 -o $i.out");   #当system函数正常运行时会返回0，报错时返回错误报警
	if ($err){   #if循环，若$err为真则打印$err即错误报警
		print "$err\n";
	}
}

my $result=();
#在perl中系统调用有两种方式，一种是system(cmd),另一种是`system`
$result = system('ls');   #命令的结果并不会返回给$result,而是直接打印到屏幕
$result = `ls`;   #则能获取到命令的执行结果
#如果要调用系统命令然后处理命令执行的结果，就需要使用`cmd`,而不是system


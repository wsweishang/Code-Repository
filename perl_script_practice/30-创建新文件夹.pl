#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;

my $filename="E:/MyTaskFolder/2008_10/task_name";
mkdir ($filename);
if (-e $filename){
	print "File exists\n";
}else{
	mkdir ($filename);
}




#mkdir "E:\中国"; 
#mkdir "E:\中国\\河南省"; # \\为转义字符，表示\，如果只有一个\，则Perl无法识别，会新建文件夹：中国河南省，而不是中国\河南省
##或者 
#mkdir "E:/中国"; 
#mkdir "E:/中国/河南省"; # / 和 \\ 的效果相同
##或者
#$filesfold_1="E:/中国";
#$filesfold_2="E:/中国/河南省";
#mkdir $filesfold_1;
#mkdir $filesfold_2;
##也可以添加注释：
#$filesfold_1="E:/中国"; 
#$filesfold_2="E:/中国/河南省/南阳市"; 
#mkdir $filesfold_1 or die "找不到父文件夹 中国 \n"; 
#mkdir $filesfold_2 or die "找不到父文件夹 中国\\河南省 \n"; #只有在dos下运行，才能看到提示信息。除 die 函数以外，还可以使用 warn函数 和 eval函数。 
##Perl的 mkdir 函数不能在父文件夹不存在的情况下直接建立子文件夹（似乎在Unix下可以，但在Win下不可以），所以要逐级建立文件夹。换言之，mkdir 函数只能在已有的文件夹下建立新的文件夹。 
##====================================================================================== 
##Perl中用于删除文件夹的函数为：rmdir ,且只能用于删除空文件夹、只能删除最低级的子文件夹，而不能直接删除包含子文件夹的父文件夹。 
##如：
#mkdir "中国"; 
#mkdir "中国/河南省"; 
#mkdir "中国/河南省/南阳市"; # 逐级生成文件夹 
#rmdir "中国/河南省/南阳市"; 
#rmdir "中国/河南省"; 
#rmdir "中国"; # 逐级删除文件夹 
##或者
#my $del="rd 中国"; 
#system $del; # 调用批处理命令 rd ，但是只能用于删除空文件夹，效果与 rmdir 相同
##或者
#system "rd 中国";
##批量删除文件夹(此行命令运行一次只能删除一个子文件夹，而不能一次性删除所有子文件夹，此问题尚无法解决)：
#mkdir "中国"; 
#mkdir "中国/河南省"; 
#mkdir "中国/广东省"; 
#mkdir "中国/山东省"; 
#mkdir "中国/浙江省"; 
#mkdir "中国/江苏省"; # 在一个父文件夹下建立多个子文件夹 
#rmdir glob "中国/*"; # 删除多个子文件夹(此行命令运行一次只能删除一个子文件夹，而不能一次性删除所有子文件夹，此问题尚无法解决) 
#rmdir "中国";
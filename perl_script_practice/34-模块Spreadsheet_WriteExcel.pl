#!/usr/bin/perl

use strict;
use warnings;
use Spreadsheet::WriteExcel;
use DBI;

##很久以前就有了这个想法，就是一直没有认真探究到底怎么把perl处理后的结果输出到excel。最近又遇到了类似的问题，于是下定决心一探究竟
##查了一些资料，发现了Spreadsheet::WriteExcel这个模块，如果能很好的使用这个模块，从perl输出到excel的操作也就没什么问题了
##利用它的几个函数，就可以方便地把数据写入到Excel相应的位置中，同时还可以设置单元格的格式，如字体大小，单元格大小，是否加粗，底色等等
##这一篇为基础篇，主要包括以下内容
##如何安装perl模块Spreadsheet::WriteExcel
##如何用perl创建excel表格
##如何进行输出的格式设置
##如何进行简单的输出
##
##1.模块Spreadsheet::WriteExcel的安装
##2.用perl创建excel表格
###************生成Excel文档****************  
#my $xl = Spreadsheet::WriteExcel->new("TEST.xls");  #引号中为生成的excel的名称，瘦箭头后面都是模块Spreadsheet::WriteExcel中的方面
##生成Excel表  
#my $xlsheet = $xl->add_worksheet("TestSheet");  #引号中为excel工作簿中表的名称
#$xlsheet->freeze_panes(1, 0); #冻结首行
#
##3.输出的格式设置
#
##添加格式（表头）
#my $rptheader = $xl->add_format(); # Add a format
#$rptheader->set_bold(); #加粗
#$rptheader->set_size('18'); #字体大小
#$rptheader->set_align('center'); #居中
#$rptheader->set_font('BrowalliaUPC'); #字体
##添加格式（表内容）
#my $normcell = $xl->add_format(); # Add a format
#$normcell->set_size('11');
#$normcell->set_align('center');
#$normcell->set_bg_color('21'); #背景色
##设置列的宽度
#$xlsheet->set_column('A:A',12);
#$xlsheet->set_column('B:B',10);
#$xlsheet->set_column('C:C',14);
#
##4.输出
#
##写表头（格式是使用上面添加的表头格式） 
#$xlsheet->write("A1","Number", $rptheader); #格式为(单元格位置，写入的内容，格式)
#$xlsheet->write("B1","Name",$rptheader);
#$xlsheet->write("C1","Language",$rptheader);
##写内容（格式是使用上面添加的表内容格式）
#$xlsheet->write("A2","1", $normcell);
#$xlsheet->write("B2","Test",$normcell);
#$xlsheet->write("C2","Perl",$normcell);
##关闭操作excel的对象.
#$xl->close();
#
#
##接上一篇博文，这一篇中主要解决大批量数据输出到excel中的问题
##这里以从数据库中输出查询结果为例：
##1.连接数据库及查询
##关于perl连接MySQL数据库详见
##http://blog.sina.com.cn/s/blog_6a6c136d01016138.html
#
#my $user = 'xx';
#my $password = '123456';
#my $dsn = 'DBI:mysql:database=test;host=192.168.1.130;port=3306';
#my $dbh = DBI->connect ($dsn, $user, $password, { RaiseError => 1, AutoCommit => 0 }) ;
#my $sth = $dbh->prepare("
#    SELECT DISTINCT a.*,b.* FROM table1 a LEFT OUTER JOIN table2 b
#    ON a.Chromosome = b.`chromosome`
#    AND a.`Min`
#    AND a.`Max`>b.`start_position`
#    ORDER BY ID
#");
#$sth->execute() or die "$DBI::errstr\n";
#
#2.创建excel表格及表格格式的设置
#
##以下用于生成excel文件
#my $xl = Spreadsheet::WriteExcel->new("result.xls");
#my $xlsheet = $xl->add_worksheet("sheet1");
#$xlsheet->freeze_panes(1, 0); #冻结首行
##添加格式（表头）
#my $rptheader = $xl->add_format(); # Add a format
#$rptheader->set_bold();
#$rptheader->set_size('12');
#$rptheader->set_font('Century Gothic');
##添加格式（表内容）
#my $normcell = $xl->add_format(); # Add a format
#$normcell->set_size('11');
#
#3.输出
#最大的差别是这一步
#
#@head_line = qw/ID File CN_State Type/; #可以把需要输出的列头放在这数组中
#my @col_name0 = ("A".."ZZ");  #最大列数到ZZ，702列，一般没有这么多列，所有ZZ就够用了
#foreach (@head_line){  #这个循环用于输出列头
#    my $col = shift @col_name0;  #每次得到一个表示列的字母
#    $xlsheet->write("$col"."1","$_", $rptheader); 
#}
#my @row;
#my $num = 2; #以下内容输出的起始列
#while (@row = $sth->fetchrow_array() ){    #这个循环用于查询结果的输出
#    my @col_name = ("A".."ZZ");  #同上
#    foreach (0..$#row) {   
#        my $col = shift @col_name;
#        $xlsheet->write ("$col"."$num",$row[$_],$normcell);
#    }
#    $num++;
#}
#
#$dbh->disconnect();














#my %us;
#while(($key, $value) = each %us){
#	print "$key|$value\n";
#}
# 
# 
# 
# 
## 创建一个新的EXCEL文件  
#my $workbook = Spreadsheet::WriteExcel->new('poi_count_top15.xls');  
#   
## 添加一个工作表  
#$worksheet = $workbook->add_worksheet(); 
#  
##  新建一个样式  
#$format = $workbook->add_format(); # Add a format 
#$format->set_bg_color('green');
#$format->set_bold();#设置字体为粗体  
#$format->set_color('red');#设置单元格前景色为红色  
#$format->set_align('center');#设置单元格居中   
#  
#  
#$format2=$workbook->add_format();
#$format2->set_bg_color('gray');
#$format2->set_bold();#设置字体为粗体 
#$format2->set_align('center');#设置单元格居中 
#  
#  
#$format3=$workbook->add_format();
#$format3->set_bg_color('orange');
#$format3->set_bold();#设置字体为粗体 
#$format3->set_align('center');#设置单元格居中 
#  
#  
#$format4=$workbook->add_format();
#$format4->set_bg_color('brown');
#$format4->set_bold();#设置字体为粗体 
#$format4->set_align('center');#设置单元格居中 
#   
#   
#$worksheet->write(0,0,'Province',$format);
#$worksheet->write(0,1,'us_ta_1',$format);  
#$worksheet->write(0,2,'us_ta_2',$format);  
#$worksheet->write(0,3,'D-value',$format);  
#$worksheet->write(0,4,'Divide us_ta_1',$format);  
#$worksheet->write(0,5,'Divide us_ta_2',$format);  
#$worksheet->write(0,6,'Result',$format);  
#$worksheet->write(0,7,'us_ta_1',$format);  
#$worksheet->write(0,8,'us_ta_2',$format);  
#$worksheet->write(0,9,'D-value',$format);  
#$worksheet->write(0,10,'Divide us_ta_1',$format);  
#$worksheet->write(0,11,'Divide us_ta_2',$format);  
#$worksheet->write(0,12,'Result',$format);                                                              
#                                   
#   
#$col = 0;
#$row = 1;
#for my $key(sort keys %us){
#	my @k=split/;/,$us{$key},-1;
#	$worksheet->write($row,0,$key,$format2);  
#	for($i=1;$i<13;$i++){
#		if($i<7){
#			$worksheet->write($row,$i,$k[$i-1],$format3);  
#		}else{
#			$worksheet->write($row,$i,$k[$i-1],$format4);
#		}
#	}
#	$row++;
#}









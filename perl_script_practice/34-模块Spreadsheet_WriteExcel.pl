#!/usr/bin/perl

use strict;
use warnings;
use Spreadsheet::WriteExcel;
use DBI;

##�ܾ���ǰ����������뷨������һֱû������̽��������ô��perl�����Ľ�������excel����������������Ƶ����⣬�����¶�����һ̽����
##����һЩ���ϣ�������Spreadsheet::WriteExcel���ģ�飬����ܺܺõ�ʹ�����ģ�飬��perl�����excel�Ĳ���Ҳ��ûʲô������
##�������ļ����������Ϳ��Է���ذ�����д�뵽Excel��Ӧ��λ���У�ͬʱ���������õ�Ԫ��ĸ�ʽ���������С����Ԫ���С���Ƿ�Ӵ֣���ɫ�ȵ�
##��һƪΪ����ƪ����Ҫ������������
##��ΰ�װperlģ��Spreadsheet::WriteExcel
##�����perl����excel���
##��ν�������ĸ�ʽ����
##��ν��м򵥵����
##
##1.ģ��Spreadsheet::WriteExcel�İ�װ
##2.��perl����excel���
###************����Excel�ĵ�****************  
#my $xl = Spreadsheet::WriteExcel->new("TEST.xls");  #������Ϊ���ɵ�excel�����ƣ��ݼ�ͷ���涼��ģ��Spreadsheet::WriteExcel�еķ���
##����Excel��  
#my $xlsheet = $xl->add_worksheet("TestSheet");  #������Ϊexcel�������б������
#$xlsheet->freeze_panes(1, 0); #��������
#
##3.����ĸ�ʽ����
#
##��Ӹ�ʽ����ͷ��
#my $rptheader = $xl->add_format(); # Add a format
#$rptheader->set_bold(); #�Ӵ�
#$rptheader->set_size('18'); #�����С
#$rptheader->set_align('center'); #����
#$rptheader->set_font('BrowalliaUPC'); #����
##��Ӹ�ʽ�������ݣ�
#my $normcell = $xl->add_format(); # Add a format
#$normcell->set_size('11');
#$normcell->set_align('center');
#$normcell->set_bg_color('21'); #����ɫ
##�����еĿ��
#$xlsheet->set_column('A:A',12);
#$xlsheet->set_column('B:B',10);
#$xlsheet->set_column('C:C',14);
#
##4.���
#
##д��ͷ����ʽ��ʹ��������ӵı�ͷ��ʽ�� 
#$xlsheet->write("A1","Number", $rptheader); #��ʽΪ(��Ԫ��λ�ã�д������ݣ���ʽ)
#$xlsheet->write("B1","Name",$rptheader);
#$xlsheet->write("C1","Language",$rptheader);
##д���ݣ���ʽ��ʹ��������ӵı����ݸ�ʽ��
#$xlsheet->write("A2","1", $normcell);
#$xlsheet->write("B2","Test",$normcell);
#$xlsheet->write("C2","Perl",$normcell);
##�رղ���excel�Ķ���.
#$xl->close();
#
#
##����һƪ���ģ���һƪ����Ҫ������������������excel�е�����
##�����Դ����ݿ��������ѯ���Ϊ����
##1.�������ݿ⼰��ѯ
##����perl����MySQL���ݿ����
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
#2.����excel��񼰱���ʽ������
#
##������������excel�ļ�
#my $xl = Spreadsheet::WriteExcel->new("result.xls");
#my $xlsheet = $xl->add_worksheet("sheet1");
#$xlsheet->freeze_panes(1, 0); #��������
##��Ӹ�ʽ����ͷ��
#my $rptheader = $xl->add_format(); # Add a format
#$rptheader->set_bold();
#$rptheader->set_size('12');
#$rptheader->set_font('Century Gothic');
##��Ӹ�ʽ�������ݣ�
#my $normcell = $xl->add_format(); # Add a format
#$normcell->set_size('11');
#
#3.���
#���Ĳ������һ��
#
#@head_line = qw/ID File CN_State Type/; #���԰���Ҫ�������ͷ������������
#my @col_name0 = ("A".."ZZ");  #���������ZZ��702�У�һ��û����ô���У�����ZZ�͹�����
#foreach (@head_line){  #���ѭ�����������ͷ
#    my $col = shift @col_name0;  #ÿ�εõ�һ����ʾ�е���ĸ
#    $xlsheet->write("$col"."1","$_", $rptheader); 
#}
#my @row;
#my $num = 2; #���������������ʼ��
#while (@row = $sth->fetchrow_array() ){    #���ѭ�����ڲ�ѯ��������
#    my @col_name = ("A".."ZZ");  #ͬ��
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
## ����һ���µ�EXCEL�ļ�  
#my $workbook = Spreadsheet::WriteExcel->new('poi_count_top15.xls');  
#   
## ���һ��������  
#$worksheet = $workbook->add_worksheet(); 
#  
##  �½�һ����ʽ  
#$format = $workbook->add_format(); # Add a format 
#$format->set_bg_color('green');
#$format->set_bold();#��������Ϊ����  
#$format->set_color('red');#���õ�Ԫ��ǰ��ɫΪ��ɫ  
#$format->set_align('center');#���õ�Ԫ�����   
#  
#  
#$format2=$workbook->add_format();
#$format2->set_bg_color('gray');
#$format2->set_bold();#��������Ϊ���� 
#$format2->set_align('center');#���õ�Ԫ����� 
#  
#  
#$format3=$workbook->add_format();
#$format3->set_bg_color('orange');
#$format3->set_bold();#��������Ϊ���� 
#$format3->set_align('center');#���õ�Ԫ����� 
#  
#  
#$format4=$workbook->add_format();
#$format4->set_bg_color('brown');
#$format4->set_bold();#��������Ϊ���� 
#$format4->set_align('center');#���õ�Ԫ����� 
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









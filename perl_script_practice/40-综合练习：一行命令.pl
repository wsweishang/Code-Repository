#!/usr/bin/perl

use strict;
use warnings;

#用perl将fasta文件格式化、去格式化
#用perl格式化Fasta文件，将其转换为可视化更好的形式，id行之后，seq每行输出70个碱基；
#perl -lne  'if(/>/){print "$_";}else{$len=length($_);for($star=0;$star<$len;$star+=70){$output=substr($_,$star,70);print "$output"; } }'  in.fa > out.fa
#open ()
#
#if(/>/){
#	print "$_";
#}else{
#	$len=length($_);
#	for($star=0;$star<$len;$star+=70){
#		$output=substr($_,$star,70);
#		print "$output";
#	}
#}



#常规fasta文件去格式为一行id一行seq；
#perl -ne 'if (/^>/){$seq=~s/\r?\n(.)/$1/g;print $seq;$seq=q{};print;}else{$seq.=$_}END{$seq=~s/\r?\n(.)/$1/g;print $seq;}' in.fa > out.fa
#用perl统计碱基数目、GC含量、read数、最长的read、最短的read及平均read长度
#用于fastq格式文件的碱基数目和GC含量的统计
#perl -ne  'if($.%4){chomp;$count_G=$count_G+($_=~tr/G//);$count_C=$count_C+($_=~tr/C//);$cur_length=length($_);$total_length+=$cur_length;}END{print qq{total count is $total_length bp\nGC%:},($count_G+$count_C)/$total_length,qq{\n} }' input.fq
#用于fasta格式文件的碱基数目和GC含量的统计
#perl -ne  'if($.%2){chomp;$count_G=$count_G+($_=~tr/G//);$count_C=$count_C+($_=~tr/C//);$cur_length=length($_);$total_length+=$cur_length;}END{print qq{total count is $total_length bp\nGC%:},($count_G+$count_C)/$total_length,qq{\n} }' input.fa
#也用于fasta格式文件的碱基数目和GC含量的统计
#grep -v '>' input.fa| perl -ne  '{$count_A=$count_A+($_=~tr/A//);$count_T=$count_T+($_=~tr/T//);$count_G=$count_G+($_=~tr/G//);$count_C=$count_C+($_=~tr/C//);$count_N=$count_N+($_=~tr/N//)};END{print qq{total count is },$count_A+$count_T+$count_G+$count_C+$count_N, qq{\nGC%:},($count_G+$count_C)/($count_A+$count_T+$count_G+$count_C+$cont_N),qq{\n} }'
#用于fastq格式文件的read数、碱基数、最长的read、最短的read及平均read长度
#perl -ne 'BEGIN{$min=1e10;$max=0;}next if ($.%4);chomp;$read_count++;$cur_length=length($_);$total_length+=$cur_length;$min=$min>$cur_length?$cur_length:$min;$max=$max<$cur_length?$cur_length:$max;END{print qq{Totally $read_count reads\nTotally $total_length bases\nMAX length is $max bp\nMIN length is $min bp \nMean length is },$total_length/$read_count,qq{ bp\n}}' input.fq
#用于fasta格式文件的read数、碱基数、最长的read、最短的read及平均read长度
#perl -ne 'BEGIN{$min=1e10;$max=0;}next if ($.%2);chomp;$read_count++;$cur_length=length($_);$total_length+=$cur_length;$min=$min>$cur_length?$cur_length:$min;$max=$max<$cur_length?$cur_length:$max;END{print qq{Totally $read_count reads\nTotally $total_length bases\nMAX length is $max bp\nMIN length is $min bp \nMean length is },$total_length/$read_count,qq{ bp\n}}' input.fq

#用perl统计Contig数目、平均contig长度、碱基数目、N50、N90
#perl -e 'my ($len,$total)=(0,0);my @x;while(<>){if(/>/){$contig++;}if(/^[\>\@]/){if($len>0){$total+=$len;push@x,$len;};$len=0;}else{s/\s//g;$len+=length($_);}}if ($len>0){$total+=$len;$mean=$total/$contig;push @x,$len;}@













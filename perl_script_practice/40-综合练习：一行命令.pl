#!/usr/bin/perl

use strict;
use warnings;

#��perl��fasta�ļ���ʽ����ȥ��ʽ��
#��perl��ʽ��Fasta�ļ�������ת��Ϊ���ӻ����õ���ʽ��id��֮��seqÿ�����70�������
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



#����fasta�ļ�ȥ��ʽΪһ��idһ��seq��
#perl -ne 'if (/^>/){$seq=~s/\r?\n(.)/$1/g;print $seq;$seq=q{};print;}else{$seq.=$_}END{$seq=~s/\r?\n(.)/$1/g;print $seq;}' in.fa > out.fa
#��perlͳ�Ƽ����Ŀ��GC������read�������read����̵�read��ƽ��read����
#����fastq��ʽ�ļ��ļ����Ŀ��GC������ͳ��
#perl -ne  'if($.%4){chomp;$count_G=$count_G+($_=~tr/G//);$count_C=$count_C+($_=~tr/C//);$cur_length=length($_);$total_length+=$cur_length;}END{print qq{total count is $total_length bp\nGC%:},($count_G+$count_C)/$total_length,qq{\n} }' input.fq
#����fasta��ʽ�ļ��ļ����Ŀ��GC������ͳ��
#perl -ne  'if($.%2){chomp;$count_G=$count_G+($_=~tr/G//);$count_C=$count_C+($_=~tr/C//);$cur_length=length($_);$total_length+=$cur_length;}END{print qq{total count is $total_length bp\nGC%:},($count_G+$count_C)/$total_length,qq{\n} }' input.fa
#Ҳ����fasta��ʽ�ļ��ļ����Ŀ��GC������ͳ��
#grep -v '>' input.fa| perl -ne  '{$count_A=$count_A+($_=~tr/A//);$count_T=$count_T+($_=~tr/T//);$count_G=$count_G+($_=~tr/G//);$count_C=$count_C+($_=~tr/C//);$count_N=$count_N+($_=~tr/N//)};END{print qq{total count is },$count_A+$count_T+$count_G+$count_C+$count_N, qq{\nGC%:},($count_G+$count_C)/($count_A+$count_T+$count_G+$count_C+$cont_N),qq{\n} }'
#����fastq��ʽ�ļ���read��������������read����̵�read��ƽ��read����
#perl -ne 'BEGIN{$min=1e10;$max=0;}next if ($.%4);chomp;$read_count++;$cur_length=length($_);$total_length+=$cur_length;$min=$min>$cur_length?$cur_length:$min;$max=$max<$cur_length?$cur_length:$max;END{print qq{Totally $read_count reads\nTotally $total_length bases\nMAX length is $max bp\nMIN length is $min bp \nMean length is },$total_length/$read_count,qq{ bp\n}}' input.fq
#����fasta��ʽ�ļ���read��������������read����̵�read��ƽ��read����
#perl -ne 'BEGIN{$min=1e10;$max=0;}next if ($.%2);chomp;$read_count++;$cur_length=length($_);$total_length+=$cur_length;$min=$min>$cur_length?$cur_length:$min;$max=$max<$cur_length?$cur_length:$max;END{print qq{Totally $read_count reads\nTotally $total_length bases\nMAX length is $max bp\nMIN length is $min bp \nMean length is },$total_length/$read_count,qq{ bp\n}}' input.fq

#��perlͳ��Contig��Ŀ��ƽ��contig���ȡ������Ŀ��N50��N90
#perl -e 'my ($len,$total)=(0,0);my @x;while(<>){if(/>/){$contig++;}if(/^[\>\@]/){if($len>0){$total+=$len;push@x,$len;};$len=0;}else{s/\s//g;$len+=length($_);}}if ($len>0){$total+=$len;$mean=$total/$contig;push @x,$len;}@













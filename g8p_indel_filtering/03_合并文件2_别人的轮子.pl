#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use File::Basename;

#============================================
#�ϲ��ļ�
#============================================

my %data=();
my @files = glob "*.txt";
foreach my $file(@files){
	my $file_name = basename ($file);
	open my $fh, '<', $file or die $!;   #ע��open�������÷�
	while (<$fh>){
		next if /^\s*$/;
		next if /^gene_number/;
		chomp;
		my ($num, $pos, $snp) = split;
		$data{$num}{$pos}{$file_name} = $snp;   #ע���ϣ�������÷�           
	}
	close $fh;
}

print "gene_number\tposition";
foreach my $file(sort @files){
	my $file_name = basename ($file);
	print "\t$file_name";
}
print "\n";

foreach my $num(sort keys %data){   #ȡ��num
	foreach my $pos(sort keys %{$data{$num}}){   #ȡ��pos
		print "$num\t$pos";
		foreach my $file(sort @files){
			my $file_name = basename ($file);
			if (exists $data{$num}{$pos}{$file_name}){
				print "\t$data{$num}{$pos}{$file_name}";
			}else{
				print "\tNA";
			}
		}
		print "\n";
	}
}


#============================================
#����ϲ��ļ�
#============================================

my $name_1="G:/1.txt";
my $name_2="G:/2.txt";   #�õ������в���

#open the ori perlterm script
open (TXT_1,"<$name_1");
open (TXT_2,"<$name_2");   #�õ������ļ����
my @a=<TXT_1>;
my @b=<TXT_2>;   #�õ������ļ�����
my $line_b=@b;   #b.txt�ļ����ݴ���

my $count_line=0;   #��ʼ���ļ�����
open my $newfile,">","G:/c.txt";   #�������ɵ����ļ��;��
foreach (@a){   #ѭ����ʼ����ϲ�
	chomp;
	say $newfile $_;
	say $_;
	if ($count_line <= $line_b){   #������ifֻ��ִ��һ�ε�����
		print $newfile $b[$count_line];
		print $b[$count_line];
		$count_line+=1;
	}
}
close ($newfile) or warn "can not close the file";   #�رվ��



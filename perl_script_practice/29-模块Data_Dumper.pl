#!/usr/bin/perl

use v5.10.0;
use strict;
use warnings;
use Data::Dumper;

#=============================================================================
#Data::Dumperģ��������ʾ���������ݽṹ�����ڼ�������й�����ʱ�������
#��Ҫ������ӡ��ϣ�������Ͳ���дforѭ����ô������
#=============================================================================
my %hash=(
	"China"=>"Asia",
	"USA"=>"North Am",
	"Canada"=>"North Am",
	"England"=>"Europe",
	"Greece"=>"Europe",
	"Japan"=>"Asia",
	"Mexico"=>"North Am",
	"France"=>"Europe",
	"South Africa"=>"Africa"
);
print Dumper (\%hash);

my $my_scalar = "This is my scalar";
my @my_array = ("hello", "world", "123", 456);
my %my_hash = ( itmeA=> 12.4, itemB=> 1.72e30, itemC=>"bye/n");
print Dumper ($my_scalar);
print Dumper (\@my_array);
print Dumper (\%my_hash);

# ��������������Ļ�ϴ�ӡ��3�����������ݽṹ���е㲻ˬ���ǣ�ÿ�����������Ʋ�����ӡ������ֻ���ü򵥵�var1��var2������
# ��Ҫ�ѱ������ͱ���ֵͬʱ��ʾ��Ҫ��dumper����ķ�����д���ϴ���
my $dump_name=Data::Dumper->new([$my_scalar,\@my_array,\%my_hash],[qw(*111 *222 *333)]);    
print $dump_name->Dump;

#========================================================================
#Ҳ���Ժϲ���ϣ
#========================================================================
my %A=();
my %B=();
my %merged=();
#========================================================================
%merged=(%A, %B);
#========================================================================
%merged=();
while (my ($k,$v)=each (%A)){
    $merged{$k}=$v;
}
while (my ($k,$v)=each (%B)){
    $merged{$k}=$v;
}
#========================================================================
# %food_color as per the introduction
my %food_color=(
	"Galliano"=>"yellow",
	"Mai Tai"=>"blue"
);
 
#%ingested_color = (%drink_color, %food_color);
#========================================================================
# %food_color per the introduction, then
my %drink_color=(
	"Galliano1"=>"yellow",
	"Mai Tai1"=>"blue"
);
my %substance_color=();
while (my ($k,$v)=each %food_color){
	$substance_color{$k}=$v;
}
while (my ($k,$v)=each %drink_color){
	$substance_color{$k}=$v;
}
print Data::Dumper->Dumper(\%substance_color);
print "\n";
#========================================================================
foreach my $substanceref(\%food_color,\%drink_color){
	while (my ($k,$v)=each %$substanceref){
		$substance_color{$k}=$v;
	}
}
#========================================================================
foreach my $substanceref(\%food_color,\%drink_color){
	while (my ($k,$v)=each %$substanceref){
		if (exists $substance_color{$k}){
			print "Warning: $k seen twice. Using the first definition.\n";
            next;
		}
		$substance_color{$k}=$v;
	}
}
#========================================================================
#@all_colors{keys %new_colors} = values %new_colors;
#========================================================================
#�����
#$VAR1 = 'Data::Dumper';
#$VAR2 = {
#          'Mai Tai1' => 'blue',
#          'Mai Tai' => 'blue',
#          'Galliano1' => 'yellow',
#          'Galliano' => 'yellow'
#        };
#Warning: Galliano seen twice.  Using the first definition.
#Warning: Mai Tai seen twice.  Using the first definition.
#Warning: Galliano1 seen twice.  Using the first definition.
#Warning: Mai Tai1 seen twice.  Using the first definition.






#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#=================================
#perl��ϣHASH����������ʹ��
#=================================
my %last_name1=("zhangsan"=>"zhang","lisi"=>"li","wangwu"=>"wang");
#��һ�ַ���������Щ
my %last_name2=(
	"zhangsan"=>"zhang",
	"lisi"=>"li",
	"wangwu"=>"wang"
);

#ȡ����ϣ��ֵ
print $last_name1{"zhangsan"}."\n";

#���丳ֵһ�Լ�ֵ
$last_name1{"maliu"}="ma";
print $last_name1{"maliu"}."\n";

#���¶�һ�Լ�ֵ��ֵ���ᷢ������
$last_name1{"zhangsan"}="san";
print $last_name1{"zhangsan"}."\n";

#ɾ��ĳ��ϣ���е�һ�Լ�ֵ
#delete $last_name1{"wangwu"};
#print $last_name1{"wangwu"}."\n";   #���ֱ���˵����ֵ�Ѿ�ɾ��

#������if�����ĳһ�Լ�ֵ�Ƿ����
if (exists $last_name1{"wangwu"}){
	print $last_name1{"wangwu"}."\n";
}else{
	print "nothing\n";
};

#keys��ȡhash���еļ�
#values��ȡhash���е�ֵ
my @keys_name1=keys(%last_name1);
my @values_name1=values(%last_name1);
say @keys_name1;
say @values_name1;

#=================================
#����ѭ����ȡhash��ֵ��
#=================================
my %last_data=('google'=>'google.com',
	'baidu'=>'baidu.com',
	'taobao'=>'taobao.com');
#whileѭ��
while(my ($k,$v)=each %last_data){
	say "$k=>$v";
};

#for��foreachѭ��
foreach my $k(sort keys (%last_data)){   #sort������������
	my $v=$last_data{$k};
	say "$k=>$v";
	say "$k=>$last_data{$k}";
};

#=================================
#perl��ϣHASH����������ʹ��
#=================================
my %funcHash0 = (
	"key1",100, 
	"key2",200, 
	"key3",300
);

#��ת��ϣ��ֵ
%funcHash0 = reverse %funcHash0;  #��ת����key-value --> value-key
 
#���ֶ��巽���ܸ���ȷ�Ǹ���key���Ǹ���value
%funcHash0 = (
    "key4" => 1,
    "key5" => 2,
    "key6" => 3,
    "key7" => 4
);
 
#��hash�в���һ����Ԫ�أ�ֻ��Ҫֱ�Ӹ�ֵ���ɣ����򸲸ǣ������½�
$funcHash0{"key8"}=5;
 
my @hash_to_array = %funcHash0;
print "hash_to_array: @hash_to_array \n";
 
#hash ����
#����keys����hash���е�keys�� ����values�������е�values
my %funcHash1 = (
	"a"=>1,
	"b"=>2,
	"c"=>3
);
my @k = keys(%funcHash1);
my @v = values(%funcHash1);
print "keys: @k\n";
print "values: @v\n";
 
 
#����each ����key/value�б� ���ڵ���hashÿһ��Ԫ��
my %funcHash2 = (
	"a"=>4,
	"b"=>5,
	"c"=>6,
	"d"=>0
);
while(my($key,$value)=each %funcHash2){
    print "$key --> $value\n";
}
 
#hash�Ĵ洢������ģ�������sort����
foreach my $key (sort(keys(%funcHash2))){
    my $value = $funcHash2{$key};
    print "key: $key => value: $value\n";
}
 
#exists �������鿴hash���Ƿ���ĳ��key
if(exists $funcHash2{"a"}){
    print "funcHash2 �д������key\n";
}else{
    print "funcHash2 �в��������key\n";
}
#���ʡ��exists,����ͨ��value��undef������0�жϲ����ڣ���value==0�Ǵ��ڵ�Ԫ��
if($funcHash2{"d"}){
    print "funcHash2 �д������key\n";
}else{
    print "funcHash2 �в��������key\n";
}
 
#delete ������ ɾ��hash��ĳkey��Ӧ��Ԫ��
my %funcHash3 = ("a"=>11, "b"=>22, "c"=>33);
my @temp = %funcHash3;
print "@temp\n";
delete $funcHash3{"b"}; #���ص���ɾ����key����Ӧ��value 22
@temp = %funcHash3;
print "@temp\n";
 
#˫������֧�ֵ���hashԪ�أ� ����֧������hash�ڲ�
print "$funcHash3{'a'}\n";  #�����Ӧ�ĵ���Ԫ��
print "%funcHash3\n";  #��֧��������ʽ��ֱ�����$funcHash3






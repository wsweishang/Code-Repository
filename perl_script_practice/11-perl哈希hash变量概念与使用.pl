#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

#=================================
#perl哈希HASH变量概念与使用
#=================================
my %last_name1=("zhangsan"=>"zhang","lisi"=>"li","wangwu"=>"wang");
#下一种方法更清晰些
my %last_name2=(
	"zhangsan"=>"zhang",
	"lisi"=>"li",
	"wangwu"=>"wang"
);

#取出哈希的值
print $last_name1{"zhangsan"}."\n";

#补充赋值一对键值
$last_name1{"maliu"}="ma";
print $last_name1{"maliu"}."\n";

#重新对一对键值赋值，会发生覆盖
$last_name1{"zhangsan"}="san";
print $last_name1{"zhangsan"}."\n";

#删除某哈希表中的一对键值
#delete $last_name1{"wangwu"};
#print $last_name1{"wangwu"}."\n";   #出现报错，说明该值已经删除

#可以用if语句检查某一对键值是否存在
if (exists $last_name1{"wangwu"}){
	print $last_name1{"wangwu"}."\n";
}else{
	print "nothing\n";
};

#keys获取hash所有的键
#values获取hash所有的值
my @keys_name1=keys(%last_name1);
my @values_name1=values(%last_name1);
say @keys_name1;
say @values_name1;

#=================================
#两种循环获取hash键值对
#=================================
my %last_data=('google'=>'google.com',
	'baidu'=>'baidu.com',
	'taobao'=>'taobao.com');
#while循环
while(my ($k,$v)=each %last_data){
	say "$k=>$v";
};

#for或foreach循环
foreach my $k(sort keys (%last_data)){   #sort函数进行排序
	my $v=$last_data{$k};
	say "$k=>$v";
	say "$k=>$last_data{$k}";
};

#=================================
#perl哈希HASH变量概念与使用
#=================================
my %funcHash0 = (
	"key1",100, 
	"key2",200, 
	"key3",300
);

#翻转哈希键值
%funcHash0 = reverse %funcHash0;  #翻转的是key-value --> value-key
 
#这种定义方法能更明确那个是key，那个是value
%funcHash0 = (
    "key4" => 1,
    "key5" => 2,
    "key6" => 3,
    "key7" => 4
);
 
#在hash中插入一个新元素，只需要直接赋值即可，有则覆盖，无则新建
$funcHash0{"key8"}=5;
 
my @hash_to_array = %funcHash0;
print "hash_to_array: @hash_to_array \n";
 
#hash 函数
#函数keys返回hash所有的keys， 函数values返回所有的values
my %funcHash1 = (
	"a"=>1,
	"b"=>2,
	"c"=>3
);
my @k = keys(%funcHash1);
my @v = values(%funcHash1);
print "keys: @k\n";
print "values: @v\n";
 
 
#函数each 返回key/value列表， 用于迭代hash每一个元素
my %funcHash2 = (
	"a"=>4,
	"b"=>5,
	"c"=>6,
	"d"=>0
);
while(my($key,$value)=each %funcHash2){
    print "$key --> $value\n";
}
 
#hash的存储是无序的，可以用sort排序
foreach my $key (sort(keys(%funcHash2))){
    my $value = $funcHash2{$key};
    print "key: $key => value: $value\n";
}
 
#exists 函数，查看hash中是否含有某个key
if(exists $funcHash2{"a"}){
    print "funcHash2 中存在这个key\n";
}else{
    print "funcHash2 中不存在这个key\n";
}
#如果省略exists,则是通过value是undef或者是0判断不存在，但value==0是存在的元素
if($funcHash2{"d"}){
    print "funcHash2 中存在这个key\n";
}else{
    print "funcHash2 中不存在这个key\n";
}
 
#delete 函数， 删除hash中某key对应的元素
my %funcHash3 = ("a"=>11, "b"=>22, "c"=>33);
my @temp = %funcHash3;
print "@temp\n";
delete $funcHash3{"b"}; #返回的是删除的key所对应的value 22
@temp = %funcHash3;
print "@temp\n";
 
#双引号中支持单个hash元素， 但是支持整个hash内插
print "$funcHash3{'a'}\n";  #输出对应的单个元素
print "%funcHash3\n";  #不支持这种形式，直接输出$funcHash3






#!/usr/bin/python3
#coding:utf-8
#2021-09-11

########################################05.1_变量的定义和使用########################################
#变量由三部分组成：标识、类型和值
#标识：表示的是对象的数据类型 ，可使用内置函数id(obj)获取
#类型：表示的是对象的数据类型，可使用内置函数type(obj)获取
#值：表示对象所存储的具体数据，可使用print(obj)打印输出
my_name = "wei_shang"
print(my_name, "标识", id(my_name))
print(my_name, "类型", type(my_name))
print(my_name, "存储值", my_name)

########################################05.2_变量的多次赋值########################################
#多次赋值之后，该变量名会指向新的不同的内存空间
my_name = "holmes_von_einstein"
print(my_name, "标识", id(my_name))
print(my_name, "类型", type(my_name))
print(my_name, "存储值", my_name)












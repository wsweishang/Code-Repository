#!/usr/bin/python3
#coding:utf-8

########################################01_print########################################
#print("hello, world!")
#sep：用来间隔多个对象，默认值是一个空格
#end：用来设定以什么结尾。默认值是换行符 \n，我们可以换成其他字符串
#file：要写入的文件对象

#标准输入
my_name = input("your name, please\n")
print("recieved your name as:", my_name)

#标准输出
#print自带换行， +号没有空格（只能连接字符串），逗号有空格
print("hello" + "world")
print("hello", "world")

#end = ""不换行, \n也可以换行
print("1", end = "")
print("2")
print("3\n4")

#文件输出
#r    只读，若文件不存在则报错
#r+   读写，若文件不存在则报错，覆盖
#w    只写，若文件不存在则创建，覆盖
#w+   读写，若文件不存在则创建，覆盖
#a    只写，若文件不存在则创建，追加
#a+   读写，若文件不存在则创建，追加
fp = open("D:/practice1.txt", "w+")
print("hello" + "world", file = fp)
fp.close()


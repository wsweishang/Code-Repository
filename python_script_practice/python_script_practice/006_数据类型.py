#!/usr/bin/python3
#coding:utf-8
#2021-09-11

########################################06.1_常见数据类型########################################
#整数integer、浮点数float、布尔值boolean、字符串string
#整数：二进制0b、八进制0o、十六进制0x


#浮点数：无法精确存储
a = 1.1
b = 2.2
print(a + b)

from decimal import Decimal
print(Decimal("1.1") + Decimal("2.2"))

#布尔值
#True = 1
#False = 0
a = True
b = False
print(a, type(a))
print(b, type(b))

print(a + 1)
print(b + 1)

print(a + b)
print(a - b)
print(b + a)
print(b - a)

#字符串
#单引号和双引号定义的字符串必须在一行
#三引号定义的字符串可以分布在连续的多行

########################################06.2_数据类型转换########################################
#int()：其他数据类型转换为整数，并抹零取整，字符串仅限于整数字符串
#str()：其他数据类型转换为字符串
#float()：其他数据类型转换为浮点数，整数转换时加.0

my_name = "weishang"
my_age = 24
print("my name is " + my_name + ", and my age is " + str(my_age))






























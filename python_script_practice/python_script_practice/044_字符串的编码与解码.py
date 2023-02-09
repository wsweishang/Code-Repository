#!/usr/bin/python3
#coding:utf-8
#2021-10-04

########################################044_字符串的编码与解码########################################
#编码：将字符串转换为二进制数据
#解码：将二进制数据转换成字符串

s = "魏上"
print(s.encode(encoding = "GBK"))
print(s.encode(encoding = "UTF-8"))

b = s.encode(encoding = "GBK")
print(b.decode(encoding = "GBK"))

b = s.encode(encoding = "UTF-8")
print(b.decode(encoding = "UTF-8"))



























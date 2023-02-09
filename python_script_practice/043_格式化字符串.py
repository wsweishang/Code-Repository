#!/usr/bin/python3
#coding:utf-8
#2021-10-02

########################################043_格式化字符串########################################
#格式化字符串的三种方式：
#%：%s标识字符串，%i或%d标识整数、%f标识浮点数
#{}：
#f""：

name = "weishang"
age = 20
print("my name is %s, and my age is %d" %(name, age)) #元组

print("my name is {0}, and my age is {1}".format(name, age))

print(f"my name is {name}, and my age is {age}")


print("%d" %99)
print("%10d" %99) #表示宽度10
print("%.3f" %3.1415926) #保留三位小数
print("%10.3f" %3.1415926) #宽度10并保留三位小数


print("{0:.3}".format(3.1415926)) #保留三位有效数字
print("{0:.3f}".format(3.1415926)) #保留三位小数
print("{0:10.3f}".format(3.1415926)) #宽度10并保留三位小数


























































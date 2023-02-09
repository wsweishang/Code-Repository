#!/usr/bin/python3
#coding:utf-8
#2021-09-16

########################################11_比较运算符########################################
a, b = 10, 20
print("a > b ?", a > b)
print("a < b ?", a < b)
print("a >= b ?", a >= b)
print("a <= b ?", a <= b)
print("a == b ?", a == b)
print("a != b ?", a != b)
 
#==比较的是两个对象的值是否相等，不管两者在内存中的引用地址是否一样
#is比较的是两个实例对象是不是完全相同，即比较两个条件：1.标识相同、2.占用的内存地址相同
c, d = 10, 10
print(c == d)
print(c is d)
print(c is not d)

list_1 = [11, 22, 33, 44]
list_2 = [11, 22, 33, 44]
print(list_1 == list_2)
print(list_1 is list_2)
print(list_1 is not list_2)




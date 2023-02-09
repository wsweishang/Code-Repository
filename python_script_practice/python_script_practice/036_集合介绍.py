#!/usr/bin/python3
#coding:utf-8
#2021-09-28

########################################036_集合介绍########################################
#集合是没有值的字典
#和字典一样键不能重复，只会保留第一个
set_1 = {1, 2, 3, 4, 5, 6, 7, 5}
print(set_1, type(set_1))

set_2 = set(range(6))
set_3 = set([8, 9, 10])
set_4 = set((1, 2, 3, 4, 5, 6, 7))
set_5 = set("Python")

print(set_2, type(set_2))
print(set_3, type(set_3))
print(set_4, type(set_4))
print(set_5, type(set_5))

set_6 = set()
print(set_6, type(set_6))

set_7 = set_1 | set_2 | set_3 | set_5
print(set_7, type(set_7))


















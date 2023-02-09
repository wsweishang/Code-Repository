#!/usr/bin/python3
#coding:utf-8
#2021-09-29

########################################038_集合间的操作########################################
#集合在底层的存储顺序相同，因此可以直接用于比较
#调用issubset判断一个集合是否是另一个集合的子集
#调用issuperset判断一个集合是否是另一个集合的超集
#调用isdisjoint判断两个集合是否没有交集

set_1 = {1, 2, 3, 4}
set_2 = {5, 6, 7, 8}
set_3 = {1, 2, 3, 4, 5, 6, 7, 8, 9}

print(set_1 == set_2)
print(set_1 != set_2)

print(set_1.issubset(set_3))
print(set_3.issuperset(set_1))

print(set_1.isdisjoint(set_2))
print(set_1.isdisjoint(set_3))
print(set_2.isdisjoint(set_3))













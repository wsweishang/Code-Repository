#!/usr/bin/python3
#coding:utf-8
#2021-09-23

########################################26_列表########################################
#列表相当于数组
#可以存储不同的数据类型
#列表元素按顺序有序排序
#索引映射唯一个数据
#列表可以存储重复数据
#根据需要动态分配和回收内存

list_1 = ["hello", "world", "98"]
list_2 = list(["hello", "world", "98", "hello"])

print(id(list_1))
print(type(list_1))
print(list_1)

print(list_2[0], list_2[-4])

print(list_2.index("hello"))
print(list_2.index("hello", 1, 4))





















#!/usr/bin/python3
#coding:utf-8
#2021-09-26

########################################030_字典介绍########################################
#字典相当于哈希
#创建字典共有三种方式
hash_1 = {"a": 1, "b": 2, "c": 3, "d": 4}
print(hash_1, type(hash_1))

hash_2 = dict(a = 1, b = 2, c = "hello", d = "world")
print(hash_2, type(hash_2))

items = ["Fruits", "Books", "Others"]
prices = [96, 78, 85, 50]
hash_3 = {item: price for item, price in zip(items, prices)}
print(hash_3)

#1、键不允许重复，后一个值会覆盖前一个值
#2、字典当中的元素无序
#3、字典中的key必须是不可变的对象（字符串、数字）
#4、字典也可以根据需要动态地伸缩
#5、字典会浪费较大的内存
#6、字典查询速度快

hash_4 = {"a": 1, "a": 2}
print(hash_4)

hash_5 = {"a": 1, "b": 2, "c": 3, "d": 4}
print(hash_5)

#合并字典

hash_1.update(hash_2)
print(1, hash_1)



#hash_6 = dict(hash_1, **hash_2)
#print(1, hash_6)
#hash_6.update(hash_3)
#print(2, hash_6)














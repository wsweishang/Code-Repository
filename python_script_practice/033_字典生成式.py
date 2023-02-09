#!/usr/bin/python3
#coding:utf-8
#2021-09-27

########################################033_字典生成式########################################
#zip()：用于将可迭代的对象作为参数，将对象中对应的元素打包成一个元组，然后返回由这些元组组成的列表
#打包以短的列表为准
items = ["Fruits", "Books", "Others"]
prices = [96, 78, 85, 50]
array_1 = zip(items, prices) # 生成元组
print(list(array_1))

hash_1 = {item: price for item, price in zip(items, prices)}
print(hash_1)

hash_2 = {item.upper(): price for item, price in zip(items, prices)}
print(hash_2)

hash_3 = {item.lower(): price for item, price in zip(items, prices)}
print(hash_3)

number = 4
hash_4 = {"a": 1, "b": 2, "c": 3, "d": 4, "e": "hello"}
print(number in list(hash_4.values()))
print("hello" in list(hash_4.values()))



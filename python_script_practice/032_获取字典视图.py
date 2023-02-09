#!/usr/bin/python3
#coding:utf-8
#2021-09-26

########################################032_获取字典视图########################################
#keys()：获取字典中所有的键
#values()：获取字典中所有的值
#items()：获取字典中所有的键值对

hash_1 = {"a": 1, "b": 2, "c": 3, "d": 4}

hash_1_keys = hash_1.keys()
hash_1_values = hash_1.values()

print(hash_1_keys, type(hash_1_keys))
print(hash_1_values, type(hash_1_values))

hash_1_keys_list = list(hash_1_keys)
hash_1_values_list = list(hash_1_values)

print(hash_1_keys_list, type(hash_1_keys_list))
print(hash_1_values_list, type(hash_1_values_list))

hash_1_items = hash_1.items()
print(hash_1_items, type(hash_1_items))

hash_1_items_list = list(hash_1_items)
print(hash_1_items_list, type(hash_1_items_list)) # 转换之后的列表元素是元组类型














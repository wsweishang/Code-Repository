#!/usr/bin/python3
#coding:utf-8
#2021-09-28

########################################034_元组介绍########################################
#元组是不可变的序列，不能执行增删改操作
#在多任务环境下，同时操作对象时不需要加锁
#元组占用的资源较少，因此尽量使用不可变序列
#元组中存储的是对象的引用，如果元组中的对象是可变对象，则可变对象的引用不允许改变，但数据可以改变
#元组有三种创建方式
tuple_1 = ("Python", "world", 98)
print(tuple_1, type(tuple_1))

tuple_2 = tuple(("Python", "world", 98)) # 注意是双小括号
print(tuple_2, type(tuple_2))

tuple_3 = "Python", "world", 98
print(tuple_3, type(tuple_3))

tuple_4 = ("Python", ) # 只有一个元素时注意有逗号
print(tuple_4, type(tuple_4))

tuple_5 = ()
print(tuple_5, type(tuple_5))

tuple_6 = (1, [2, 3], 9)
print(tuple_6, type(tuple_6))
print(tuple_6[0], type(tuple_6[0]), id(tuple_6[0]))
print(tuple_6[1], type(tuple_6[1]), id(tuple_6[1]))
print(tuple_6[2], type(tuple_6[2]), id(tuple_6[2]))

tuple_6[1].append(100)
print(tuple_6[1], type(tuple_6[1]), id(tuple_6[1]))





































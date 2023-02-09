#!/usr/bin/python3
#coding:utf-8
#2021-09-23

########################################27_切片########################################
#和range一样左闭右开
array_1 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
array_2 = array_1[6]
array_3 = array_1[1: 6]
array_4 = array_1[1: 6: 1]
array_5 = array_1[1: 6: 2]

print(array_1)
print(array_2)
print(array_3)
print(array_4)
print(array_5)

array_6 = array_1[: 6: 2]
array_7 = array_1[1: : 2]

print(array_6)
print(array_7)

array_8 = array_1[: : -1]
array_9 = array_1[1: : 2]

print(array_8)
print(array_9)








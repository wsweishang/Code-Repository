#!/usr/bin/python3
#coding:utf-8
#2021-09-17

########################################12_布尔运算符########################################
#and：有一个False时结果为False
#or：有一个True时结果为True
#not：取反
#in/not in：查询是否存在

a, b = 1, 2
print(a == 1 and b == 2)
print(a != 1 and b == 2)
print(a == 1 and b != 2)
print(a != 1 and b != 2)

print(a == 1 or b == 2)
print(a != 1 or b == 2)
print(a == 1 or b != 2)
print(a != 1 or b != 2)

c, d = True, False
print(c, [not c], d, [not d])

e = "helloworld"
print("w" in e)
print("k" in e)
print("w" not in e)
print("k" not in e)













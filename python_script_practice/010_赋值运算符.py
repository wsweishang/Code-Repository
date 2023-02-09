#!/usr/bin/python3
#coding:utf-8
#2021-09-16

########################################10_赋值运算符########################################
#简单赋值
a = 3 + 4
print(a, type(a))

#链式赋值
b = c = d = 20
print(b, type(b), c, type(c), d, type(d))

#参数赋值（+=、-=、*=、/=、//=、%=）
e = 20
e += 30
print(e, type(e))
e -= 10
print(e, type(e))
e *= 2
print(e, type(e))
e /= 3
print(e, type(e))
e //= 2
print(e, type(e))
e %= 3
print(e, type(e))

#系列解包赋值
f, g, h = 20, 30, 40
print(f, type(f), g, type(g), h, type(h))

#互换赋值
i, j = 10, 20
print(i, type(i), j, type(j))
i, j = j, i
print(i, type(i), j, type(j))

x, y = 10, 20
print(x, y)
y = x ^ y
x = x ^ y
y = x ^ y
print(x, y)













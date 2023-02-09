#!/usr/bin/python3
#coding:utf-8
#2021-10-05

########################################050_变量的作用域########################################
#作用域：代码能访问该变量的区域，可分为局部变量（在函数内定义并使用）和全局变量（在函数体外定义）

def fun1 (a, b) :
    c= a + b #a、b、c为局部变量
    print(a, b, c)

fun1(1, 2)

d = "hello, world" #d为全局变量
def fun2 (name) :
    print(d, name)

fun2("python")

def fun3 (e, f) :
    global g
    g = e + f
    print(g)

fun3(1, 2)
print(g)












































































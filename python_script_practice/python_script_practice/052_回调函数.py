#!/usr/bin/python3
#coding:utf-8
#2021-10-07

########################################052_回调函数########################################
#函数名也可以当作参数调入另一个函数内运算，称为回调函数
def funca (a, b) :
    c = a + b
    return(c)

def funcb (a, b) :
    c = a * b
    return(c)

def funcc (func_name1, func_name2, a, b) :
    c = func_name1(a, b) - func_name2(a, b)
    return(c)

print(funcc(funca, funcb, 3, 7))








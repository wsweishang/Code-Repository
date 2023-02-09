#!/usr/bin/python3
#coding:utf-8
#2021-10-04

########################################047_函数的内存分析########################################
#函数的内存分析
def fun (arg1, arg2) :
    print("arg1 = ", arg1)
    print("arg2 = ", arg2)
    arg1 = 100
    arg2.append(10)
    print("arg1 = ", arg1)
    print("arg2 = ", arg2)

n1 = 11
n2 = [22, 33, 44]
fun(n1, n2)
print(n1)
print(n2)
    






















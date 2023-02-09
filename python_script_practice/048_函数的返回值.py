#!/usr/bin/python3
#coding:utf-8
#2021-10-04

########################################048_函数的返回值########################################
#函数返回多个值时，结果为元组

def fun1 (num) :
    odd = []
    even = []
    for i in num :
        if i % 2 :
            odd.append(i)
        else :
            even.append(i)
    return (odd, even)

print(fun1([10, 29, 34, 23, 44, 53, 55]))



























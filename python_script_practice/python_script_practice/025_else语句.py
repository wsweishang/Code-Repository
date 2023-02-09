#!/usr/bin/python3
#coding:utf-8
#2021-09-23

########################################25_else语句########################################
a = 0
while a < 3 :
    pwd = input("请输入密码")
    if pwd == "8888" :
        print("密码正确")
        break
    else :
        print("密码不正确", end = ", ")
    a += 1
else :
    print("三次密码均不正确")




























#!/usr/bin/python3
#coding:utf-8
#2021-09-21

########################################21_while循环########################################
#先判断再执行
sum_1 = 0
a = 0
while a < 5 :
    sum_1 += a
    a += 1
print(sum_1)

#计算1~100之间的偶数和
sum_2 = 0
a = 1
while a <= 100 :
    if a % 2 == 0 :
        sum_2 += a
    a += 1
print(sum_2)









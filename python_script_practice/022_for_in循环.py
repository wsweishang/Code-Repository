#!/usr/bin/python3
#coding:utf-8
#2021-09-21

########################################22_for_in循环########################################
for item in "Python" :
    print(item)

for i in range(10) :
    print(i)

#如果在循环体中不需要使用到自定义变量，可将自定义变量写为“_”
for _ in range(5) :
    print("python")

sum_item = 0
for item in range(1, 101) :
    if item %2 == 0 :
        sum_item += item
print(sum_item)

for number in range(100, 1000) :
    a = number % 10
    b = number // 10 % 10
    c = number // 100
    d = a**3 + b**3 + c**3
    if d == number :
        print(number)










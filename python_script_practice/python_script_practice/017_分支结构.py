#!/usr/bin/python3
#coding:utf-8
#2021-09-20

########################################17.1_分支结构_单分支结构########################################
# money = 1000
# s = int(input("请输入取款金额\n"))
# if money >= s : 
#     money = money - s
#     print("取款成功，余额为：", money)

########################################17.2_分支结构_双分支结构########################################
# num = int(input("请输入一个整数\n"))
# if num % 2 == 0 :
#     print(num, "是偶数")
# else :
#     print(num, "是奇数")

########################################17.3_分支结构_多分支结构########################################
score = float(input("请输入一个成绩：\n"))

if score >= 90 and score <= 100 :
    print("成绩为A")
elif score >= 80 and score < 90 :
    print("成绩为B")
elif score >= 70 and score < 80 :
    print("成绩为C")
elif score >= 60 and score < 70 :
    print("成绩为D")
elif score >= 0 and score < 60 :
    print("成绩不及格")
else :
    print("成绩有误")

########################################17.4_分支结构_嵌套if的使用########################################





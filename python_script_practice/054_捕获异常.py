#!/usr/bin/python3
#coding:utf-8
#2021-10-07

########################################054_捕获异常########################################
#try...exception
try :
    a = int(input("输入第一个数字"))
    b = int(input("输入第二个数字"))
    result = a / b
    print("结果为", result)
except ZeroDivisionError : #0作除数的异常
    print("除数不允许为0")
except ValueError : #输入非数字的异常
    print("请输入数字")
except BaseException : #所有可能出现的异常类型
    print("请输入数字")
print("程序退出")


#try...exception...else
#如果try块抛出异常，执行except块，没有抛出异常则执行else块
try :
    a = int(input("输入第一个数字"))
    b = int(input("输入第二个数字"))
    result = a / b
except BaseException as e :
    print("抛出异常", e)
else :
    print("结果为", result)
print("程序退出")


#try...exception...else...finally
#无论是否抛出异常都会执行finally块， 常用于释放try块中申请的资源
try :
    a = int(input("输入第一个数字"))
    b = int(input("输入第二个数字"))
    result = a / b
except BaseException as e :
    print("抛出异常", e)
else :
    print("结果为", result)
finally :
    print("关闭句柄")
print("程序退出")


























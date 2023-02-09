#!/usr/bin/python3
#coding:utf-8
#2021-10-07

########################################055_traceback模块########################################
#使用traceback模块可以将报错打印到日志中
import traceback
try :
    a = int(input("输入第一个数字"))
    b = int(input("输入第二个数字"))
    result = a / b
except BaseException as e :
    print("抛出异常", e)
    traceback.print_exc()
else :
    print("结果为", result)
finally :
    print("关闭句柄")
print("程序退出")















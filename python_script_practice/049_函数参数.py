#!/usr/bin/python3
#coding:utf-8
#2021-10-05

########################################049.1_函数参数_默认值参数########################################
#函数定义时，给形式参数设置默认值，只有与默认值不符的时候才需要传递实际参数

def fun1 (a, b = 10) :
    print(a, b)

fun1(100)
fun1(100, 200)

########################################049.2_函数参数_个数可变的形式参数########################################
#个数可变的位置参数：在可能无法事先确定传递的位置实际参数的个数时，使用*定义个数可变的位置形式参数，结果为一个元组
#个数可变的关键字实际参数：无法事先确定传递的关键字实际参数的个数时，使用**定义个数可变的关键字形式参数，结果为一个字典
#个数可变的位置形式参数和个数可变的关键字形式参数可以同时使用，但传入顺序要一致，且位置形式参数在关键字形式参数之前
def fun2 (*args) :
    print(args, type(args), args[0], type(args[0]))

fun2(10)
fun2(10, 20)

lst = [10, 20, 30]
fun2(*lst)
 
def fun3 (**args) :
    print(args, type(args), args["a"], type(args["a"]))

fun3(a = 10)
fun3(a = 10, b = 20)

dct = {"a": 10, "b": 20, "c": 30}
fun3(**dct)

def fun4 (*args1, **args2) :
    print(args1, type(args1), args2, type(args2))

fun4(10, a = 10)
fun4(10, 20, a = 10, b = 20)
fun4(*lst, **dct)

def fun5 (b = 10, **args) :
    args["b"] = b
    print(args, type(args), args["a"], type(args["a"]))

fun5(a = 10)
fun5(a = 10, b = 20)

def fun6 (*args, b = 10, c = 100) :
    args = tuple(list(args) + [b, c])
    print(args, type(args))

fun6(10)
fun6(10, b = 20)
fun6(10, 20, b = 20, c = 4000)

def fun7 (a, b, c, d) :
    print(a, b, c, d)

fun7(10, 20, c = 20, d = 4000)

































































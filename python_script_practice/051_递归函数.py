#!/usr/bin/python3
#coding:utf-8
#2021-10-07

########################################051_递归函数########################################
#如果一个函数内部调用了该函数本身，这个函数就被称为递归函数，由1、递归调用与2、递归终止条件组成
#每递归调用一次函数，都会在栈内存分配一个栈帧，没执行完一次函数，都会释放相应的空间
#优点：思路和代码简单；缺点：占用内存多，效率低下
def fac (num) :
    if (num == 1) :
        return(num)
    else :
        return num * fac(num - 1)

print(fac(6))


def fib (n) :
    if n == 1 :
        return 1
    elif n == 2 :
        return 1
    else :
        return fib(n - 1) + fib (n - 2)

print(fib(10))





















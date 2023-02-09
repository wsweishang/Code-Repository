#!/usr/bin/python3
#coding:utf-8
#2022-03-22

import math
#为每个模块单独创建命名空间
print(dir(math))
#使用时需要在函数名前加模块名
help(math.sqrt)

#导入单个函数
from math import log
#合并了math和python shell的命名空间
#此时函数名前不用加模块名
help(log)


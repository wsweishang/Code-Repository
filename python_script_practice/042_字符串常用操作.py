#!/usr/bin/python3
#coding:utf-8
#2021-09-30
import re

########################################042.1_字符串的查找操作########################################
#index()：查找子串第一次出现的位置，不存在时报错
#rindex()：查找子串第一次出现的位置，不存在时报错
#find()：查找子串最后一次出现的位置，不存在时返回-1
#rfind()：查找子串最后一次出现的位置，不存在时返回-1

str_1 = "Hello world"
print(str_1.index("o"))
print(str_1.rindex("o"))
print(str_1.find("o"))
print(str_1.rfind("o"))
print(str_1.find("k"))
print(str_1.rfind("k"))

########################################042.2_字符串的大小写转换操作########################################
#upper()：把字符串中所有字符都转成大写字母
#lower()：把字符串中所有字符都转成小写字母
#swapcase()：把字符串中大写转小写，小写转大写
#capitalize()：把字符串中首字母大写，其余小写
#title()：把字符串中每个单词首字母大写，其余小写

print(str_1.upper()) # 修改之后会产生一个新的字符串对象
print(str_1.lower())
print(str_1.swapcase())
print(str_1.capitalize())
print(str_1.title())

########################################042.3_字符串的内容对齐操作########################################
#center()：居中对齐，第一个参数指定宽度，第二个参数（可选，默认空格）指定填充符，设置宽度小于实际宽度则返回原字符串
#ljust()：左对齐，第一个参数指定宽度，第二个参数（可选，默认空格）指定填充符，设置宽度小于实际宽度则返回原字符串
#rjust()：右对齐，第一个参数指定宽度，第二个参数（可选，默认空格）指定填充符，设置宽度小于实际宽度则返回原字符串
#zfill()：右对齐，左边用0填充，只有一个参数指定字符串宽度，设置宽度小于实际宽度则返回原字符串，首字符负号时候会添加在负号后面

print(str_1.center(len(str_1) + 5 * 2, "*"))
print(str_1.ljust(len(str_1) + 5 * 2, "*"))
print(str_1.rjust(len(str_1) + 5 * 2, "*"))
print(str_1.zfill(len(str_1) + 5 * 2))
print("-1111".zfill(8))

########################################042.4_字符串的分割操作########################################
#split()：
#1、从字符串的左边依次分割返回一个列表，默认空格分割字符
#2、参数sep指定分割字符
#3、参数maxsplit指定最大分割次数，剩余的部分不再分割作为一个整体返回（n + 1）
#rsplit()：从右侧开始分割，其余和split()一样，返回的数组方向不变

str_2 = "hello world weishang python"
lst_1 = str_2.split(" ")
print(lst_1, type(lst_1))

lst_2 = str_2.split(" ", 1)
print(lst_2, type(lst_2))

str_3 = "hello,world,weishang,python"
lst_3 = str_3.split(",", 1)
print(lst_3, type(lst_3))


lst_4 = str_2.rsplit(" ")
print(lst_4, type(lst_4))

lst_5 = str_2.rsplit(" ", 1)
print(lst_5, type(lst_5))

str_4 = "hello,world,weishang,python"
lst_6 = str_4.rsplit(",", 1)
print(lst_6, type(lst_6))

########################################042.5_字符串的常用判断操作########################################
#isidentifier()：判断字符串是不是合法的标识符（字母数字下划线）
#isspace()：判断字符串是否全部由空白字符（回车、换行、制表符、空格）组成
#isalpha()：判断字符串是否全部由字母构成
#isdecimal()：判断字符串是否全部由十进制的数字（阿拉伯数字）构成
#isnumeric()：判断字符串是否全部由数字（阿拉伯数字、罗马数字、中文小写数字）组成
#isalnum()：判断字符串是否全部由字母和数字组成

print("hello,world,weishang,python,00".isidentifier())
print("hello_world_weishang_python_00".isidentifier())
print("\n\r\t\x20".isspace())
print("hello,world,weishang,python,00".isalpha())
print("helloworldweishangpython".isalpha())
print("1.2".isdecimal())
print("")
print("")
print("helloworldweishangpython00".isalnum())

########################################042.6_字符串的替换合并操作########################################
#join()：返回一个由指定间隔字符合并后的字符串，其他类型数据需先转换成字符格式
#re.sub()
#replace()：返回一个替换后的新字符串，第一个参数指定被替换的字串，第二个参数指定替换字串的字符串，第三个参数指定最大替换次数

lst_7 = ["p", "y", "t", "h", "o", "n"]
lst_8 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
lst_9 = range(10)

print("_".join(lst_7))
print("_".join([str(i) for i in lst_8]))
print("_".join(map(lambda i:str(i), lst_9)))
print("_".join(map(str, lst_9)))
print("_".join("helloworld"))

str_5 = "this is string example which content is that \"this is really string\""
print(re.sub(r"(?<!th)is", "was", str_5))
print(str_5.replace("is", "was", 3))

########################################042.7_字符串的指定截取替换操作########################################
#python没有专门的substr函数，指定截取替换是通过类似数组切片的方式实现的

str_5 = "abcdefghijklmnopqrstuvwxyz"
print(str_5[1: 5: 1])
print(str_5[1: -5: 1])
print(str_5[: : -1]) # 创造一个与原字符串顺序相反的字符串
print(str_5[-1: -5: -1]) # 逆序截取，start和end位置顺序也要逆序

def substr1 (string, start, length, replacement) :
    new = list(string)
    new[start: start + length: ] = list(replacement)
    return("".join(new))

print(substr1(str_5, 0, -1, "123456789"))

def substr2 (string, start, length, replacement) :
    return(string[: start] + replacement + string[start + length: ])

print(substr2(str_5, 0, -1, "123456789"))

########################################042.8_字符串的比较操作########################################
#循环两字符串的第n个字符的ASCII码，直至第一个不同的字符时返回条件判断
#>, >=, <, <=, ==, !=
#chr()：获取字符对应的ASCII码
#ord()：获取ASCII码对应的字符

print("apPle" > "appLe")
print(ord("P"), ord("p"))
print(ord("l"), ord("L"))

print("apple" > "apple")
print("apple" == "apple")

########################################042.9_字符串的切片操作########################################















































































#!/usr/bin/python3
#coding:utf-8
#2021-09-25

########################################28.1_列表元素的判断########################################
#in/not in
array = [10, 20, "python", "hello", "world"]
print(10 in array)
print(100 in array)

print(10 not in array)
print(100 not in array)

print("python" in array)
print("Python" in array)

print("python" not in array)
print("Python" not in array)

########################################28.2_列表元素的遍历########################################
for item in array :
    print(item)

########################################28.3_列表元素的添加########################################
#append()：在列表的末尾添加一个元素
#extend()：在列表的末尾添加一个列表
#insert()：在列表的任意位置上添加一个元素
#切片：在列表的任意位置上替换一个或多个元素

lst_1 = [1, 2, 3]
print(lst_1, id(lst_1))
lst_1.append(4)
print(lst_1, id(lst_1))

lst_2 = ["hello", "world"]
#lst_1.append(lst_2)
lst_1.extend(lst_2)
print(lst_1, id(lst_1))

lst_1.insert(0, 5) #从头添加
lst_1.insert(len(lst_1), 100000)
print(lst_1, id(lst_1))

lst_3 = [True, False, "hello, world"]
lst_1[1:] = lst_3
print(lst_1, id(lst_1))

########################################28.4_列表元素的删除########################################
#remove()：一次删除一个元素，重复元素只删除第一个，元素不存在抛出ValueError
#pop()：删除一个指定索引上的元素，指定索引不存在抛出IndexError，不指定索引是删除列表中最后一个元素
#切片：一次至少删除一个元素
#clear()：清空列表
#del：删除列表或元素

lst_4 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1]
print(lst_4)
lst_4.remove(1)
print(lst_4)

lst_4.pop(0)
print(lst_4)

first_element = lst_4.pop(0)
print("first_element =", first_element, lst_4)

lst_4.pop()
print(lst_4)

last_element = lst_4.pop(0)
print("last_element =", last_element, lst_4)

lst_4[1:3] = []
print(lst_4)

del lst_4[1]
print(lst_4)

lst_4.clear()
print(lst_4)

del lst_4
#print(lst_4)

########################################28.5_列表元素的修改########################################
lst_5 = [1, 2, 3, 4, 5, 6]
print(lst_5)
lst_5[3] = 1
print(lst_5)

lst_5[1: 3] = ["hello", "world"]
print(lst_5)

########################################28.6_列表元素的排序########################################
lst_6 = [20, 40, 10, 98, 54]
print(lst_6)
lst_6.sort()
print(lst_6)

lst_6.sort(reverse = True)
print(lst_6)

lst_6.sort(reverse = False)
print(lst_6)

lst_7 = sorted(lst_6, reverse = True)
print(lst_7)

lst_8 = sorted(lst_6, reverse = False)
print(lst_8)


































































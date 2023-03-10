#!/usr/bin/python3
#coding:utf-8
#2021-09-26

########################################031.1_字典元素的获取########################################
hash_1 = {"a": 1, "b": 2, "c": 3, "d": 4}
print(hash_1)

print(hash_1["a"])
print(hash_1.get("a"))

print(hash_1.get("e"))
print(hash_1.get("e", "1000"))

########################################031.2_字典元素的判断########################################
print("a" in hash_1)
print("e" in hash_1)
print("a" not in hash_1)
print("e" not in hash_1)

########################################031.3_字典元素的删除########################################
del hash_1["d"]
print(hash_1)

a = hash_1.pop("d")

hash_1.clear()
print(hash_1)

########################################031.4_字典元素的增加########################################
hash_1["d"] = 4
print(hash_1)

########################################031.5_字典元素的遍历########################################
for item in hash_1 :
    print("key =", item, "value =", hash_1[item], "value =", hash_1.get(item))


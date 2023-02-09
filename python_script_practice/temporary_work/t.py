#!/usr/bin/python3
#coding:utf-8
#2022-07-12

# a = {}
# def addvalue(thedict, key_a, key_b, val):
#     if key_a in thedict:
#         thedict[key_a].update({key_b: val})
#     else:
#         thedict.update({key_a:{key_b: val}})
# 
# for i in range(1, 10) : 
#     print(i)
#     addvalue(a, "a", "b", a.get("a", {}).get("b", 0) + 1)
# 
# #addvalue(a, "a", "b", a.get("a", {}).get("b", 0) + 1)
# 
# print(a)

line = "GGAAAATAAACATCAGTTTCTTCCAATGAAATGTCTCTCATTCTATCAAC"
print(len(line), list(range(0, len(line))))

for i in range(0, len(line)) : 
    print(line[i], end = "")















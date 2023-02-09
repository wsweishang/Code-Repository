#!/usr/bin/python3
#coding:utf-8
#2021-09-29

########################################039_集合的数学操作########################################
#.intersection()\&：交集
#.union()：并集
#.difference()\-：差集
#.symmetric_difference()：对称差集

set_1 = {1, 2, 3, 4, 5, 6}
set_2 = {4, 5, 6, 7, 8, 9}

set_1_intersection = set_1.intersection(set_2)
set_2_intersection = set_2.intersection(set_1)
print(set_1_intersection)
print(set_2_intersection)

set_1_union = set_1.union(set_2)
set_2_union = set_2.union(set_1)
print(set_1_union)
print(set_2_union)

set_1_difference = set_1.difference(set_2)
set_2_difference = set_2.difference(set_1)
print(set_1_difference)
print(set_2_difference)

set_1_symmetric_difference = set_1.symmetric_difference(set_2)
set_2_symmetric_difference = set_2.symmetric_difference(set_1)
print(set_1_symmetric_difference)
print(set_2_symmetric_difference)




















#!/usr/bin/python3
#coding:utf-8
#2022-05-16

file_size = 54671900
#file_size = 53825263
print(file_size)

def calc_divisional_range(filesize, chuck = 10): 
    step = filesize // chuck
    arr, result = [], []
    for i in range(chuck) :
        arr.append(i * step)
    
    arr.append(filesize)
    
    for i in range(len(arr) - 1): 
        s_pos, e_pos = arr[i], arr[i + 1] - 1
        result.append([s_pos, e_pos])
    return result

divisional_ranges = calc_divisional_range(file_size)
print(divisional_ranges)










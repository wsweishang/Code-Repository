#!/usr/bin/python3
#coding:utf-8
#2021-10-01

import os # 文件操作
import re # 正则表达式
import requests # 数据请求


filename = "D:/music/"
url = "https://music.163.com/#/discover/toplist?id=3778678"


#headers请求头是用来将python代码伪装成浏览器对服务器发送请求
#服务器收到请求后，会返回响应数据（response）
headers = {"user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36"}

if not os.path.exists(filename) :
    os.mkdir(filename)

response = requests.get(url = url, headers = headers)

#print(response.text)
html_data = re.findall('<li><a href="/song\?id=(\d+)">(.*?)</a>', response.text)
 
for num_id, title in html_data :
    music_url = f'http://music.163.com/song/media/outer/url?id={num_id}.mp3'
    music_content = requests.get(url = music_url, header = headers).content
    with open("D:/music/" + title + ".mp3", mode = "wb") as f :
        f.write(music_content)
    print(num_id, title)





































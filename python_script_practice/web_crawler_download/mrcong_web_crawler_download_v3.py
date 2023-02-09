#!/usr/bin/python3
#coding:utf-8
#2021-10-01

import os
import random
import requests
from bs4 import BeautifulSoup
###############################################################################################################################################
output_dir = "D:/mrcong/"
record_input_filename = "D:/mrcong/record_cloud_page_url_list.txt"

user_agent_list = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/536.36", 
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.18363"
]
headers = {
    "user-agent": "Mozilla/5.0", 
    "sec-ch-ua": '"Chromium";v="94", "Google Chrome";v="94", ";Not A Brand";v="99"', 
    "sec-ch-ua-mobile": "?0", 
    "sec-ch-ua-platform": "Windows", 
    "Accept": "text/html, application/xhtml+xml, application/xml; q=0.9, */*; q=0.8", 
    "Accept-Encoding": "gzip, deflate, br", 
    "Accept-Language": "zh-Hans-CN, zh-Hans; q=0.8, en-US; q=0.5, en; q=0.3", 
    "Cache-Control": "max-age=0", 
    "Cookie": "_gat=1; _gid=GA1.2.1358482524.1633412552; _ga=GA1.2.471444607.1633412552"
}
###############################################################################################################################################
if not os.path.exists(output_dir) :
    os.mkdir(output_dir)
###############################################################################################################################################
record_content = []

record_filehandle = open(record_input_filename, "r")

for line in record_filehandle.readlines() :
    line = tuple(line.strip('\n').split('\t'))
    record_content.append(line)
    
record_filehandle.close()

requests.DEFAULT_RETRIES = 5
s = requests.session()
s.keep_alive = False

for url in record_content[0: 10 + 1] :
    count = url[0]
    home_page_num = url[1]
    album_page_url = url[2]
    MediaUrl = url[3]
    
    url = MediaUrl
    
    requests.packages.urllib3.disable_warnings()
    headers["user-agent"] = random.choice(user_agent_list)
    
    req = requests.get(url, headers)
    soup = BeautifulSoup(req.content, 'html.parser')
    
    url = soup.find("a", class_="popsok").get('href')
    
    output_filename = soup.find("div", class_ = "filename").get_text().strip("\n")
    output_detail = soup.find("ul", class_="details").get_text().replace("\n", " ")
    print("[{0}] [{1}] [{2}] [{3}]".format(count, MediaUrl, output_filename, output_detail), end = "")
    
    requests.packages.urllib3.disable_warnings()
    headers["user-agent"] = random.choice(user_agent_list)
    
    r = requests.get(url, headers)
    
    with open(output_dir + soup.find("div", class_ = "filename").get_text(), 'wb') as f:
        f.write(r.content)
        print('Done ...')


























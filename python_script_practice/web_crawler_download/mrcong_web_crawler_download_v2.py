#!/usr/bin/python3
#coding:utf-8
#2021-10-01

import os
import re
import time
import random
import requests
from bs4 import BeautifulSoup
###############################################################################################################################################
output_dir = "D:/mrcong/"
first_home_page_url = "https://mrcong.com/"
home_page_total_number = 999
record_output_filename = "record_cloud_page_url_list.txt"

user_agent_list = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/538.36", 
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.18363"
]
headers = {
    "user-agent": "Mozilla/5.0"
#     "sec-ch-ua": '"Chromium";v="94", "Google Chrome";v="94", ";Not A Brand";v="99"', 
#     "sec-ch-ua-mobile": "?0", 
#     "sec-ch-ua-platform": "Windows", 
#     "Accept": "text/html, application/xhtml+xml, application/xml; q=0.9, */*; q=0.8", 
#     "Accept-Encoding": "gzip, deflate, br", 
#     "Accept-Language": "zh-Hans-CN, zh-Hans; q=0.8, en-US; q=0.5, en; q=0.3", 
#     "Cache-Control": "max-age=0", 
#     "Cookie": "_gat=1; _gid=GA1.2.1358482524.1633412552; _ga=GA1.2.471444607.1633412552"
}
###############################################################################################################################################
if not os.path.exists(output_dir) :
    os.mkdir(output_dir)
###############################################################################################################################################
#home_page_url_list = [first_home_page_url] + [first_home_page_url + "page/" + str(num) + "/" for num in range(2, home_page_total_number + 1)]
#home_page_url_list = list(zip(range(1, home_page_total_number + 1), home_page_url_list))
#count = 1

home_page_url_list = [first_home_page_url + "page/" + str(num) + "/" for num in range(239, home_page_total_number + 1)]
home_page_url_list = list(zip(range(239, home_page_total_number + 1), home_page_url_list))
count = 4785

requests.DEFAULT_RETRIES = 10
s = requests.session()
s.keep_alive = False

for home_page_num, home_page_url in home_page_url_list :
    requests.packages.urllib3.disable_warnings()
    headers["user-agent"] = random.choice(user_agent_list)
    
    time.sleep(random.random())
    
    home_page_response = requests.get(url = home_page_url, headers = headers, verify = False)
    
    album_page_url_list = re.findall('<a href="(https://mrcong.com/(?!tag|sets|top3|top7|tim-kiem|huong-dan|lien-he|about-us|20|category)\S+)">', home_page_response.text)
    album_page_url_list = list(set(album_page_url_list))
    
    for album_page_url in album_page_url_list :
        requests.packages.urllib3.disable_warnings()
        headers["user-agent"] = random.choice(user_agent_list)
        
        time.sleep(random.random())
        
        album_page_response = requests.get(url = album_page_url, headers = headers, verify = False)
        
        album_page_response_soup = BeautifulSoup(album_page_response.text, "html.parser")
        
        for k in album_page_response_soup.find_all("a"):
            if re.search("download", str(k), flags = re.I) :
                cloud_page_url = k.get("href")
                if (cloud_page_url) :
                    print("[{0}] [page{1}] [{2}] [{3}]".format(count, home_page_num, album_page_url, cloud_page_url))
                    
                    with open(output_dir + record_output_filename, "a") as f:
                        text = "{0}\tpage{1}\t{2}\t{3}\n".format(count, home_page_num, album_page_url, cloud_page_url)
                        f.write(text)
                        count += 1
                        
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                
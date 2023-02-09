#!/usr/bin/python3
#coding:utf-8
#2021-10-07

import os
import re
import time
import random
import urllib3
import requests
#import pretty_errors
from bs4 import BeautifulSoup
###############################################################################################################################################
output_dir = "D:/mrcong/"
first_home_page_url = "https://mrcong.com/"
#home_page_total_number = 1002
home_page_total_number = 1184
record_album_page_url_list_filename = "record_album_page_url_list.txt"
record_cloud_page_url_list_filename = "record_cloud_page_url_list_v1.txt"
#region
user_agent_list = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36", 
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36", 
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/538.36", 
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.18363", 
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24", 
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.9 Safari/536.5", 
    "Mozilla/5.0 (X11; CrOS i686 2268.111.0) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11", 
    "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3", 
    "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.36 Safari/536.5", 
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3", 
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1062.0 Safari/536.3", 
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3", 
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6", 
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1", 
    "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24", 
    "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/19.77.34.5 Safari/537.1", 
    "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3", 
    "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3", 
    "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.0 Safari/536.3", 
    "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1062.0 Safari/536.3", 
    "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1090.0 Safari/536.6", 
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3"
]
#endregion
headers = {}
###############################################################################################################################################
if not os.path.exists(output_dir) :
    os.mkdir(output_dir)
###############################################################################################################################################
# home_page_url_list = [first_home_page_url] + [first_home_page_url + "page/" + str(num) + "/" for num in range(2, home_page_total_number + 1)]
# home_page_url_list = list(zip(range(1, home_page_total_number + 1), home_page_url_list))
# count = 1
# 
# # home_page_url_list = [first_home_page_url + "page/" + str(num) + "/" for num in range(194, home_page_total_number + 1)]
# # home_page_url_list = list(zip(range(194, home_page_total_number + 1), home_page_url_list))
# # count = 3861
#   
# requests.DEFAULT_RETRIES = 10
# s = requests.session()
# s.keep_alive = False
#   
# for home_page_num, home_page_url in home_page_url_list :
#     requests.packages.urllib3.disable_warnings()
#     headers["user-agent"] = random.choice(user_agent_list)
#       
#     print(headers["user-agent"])
#       
# #    time.sleep(random.uniform(1, 2))
#     time.sleep(random.random())
#       
#     requests.DEFAULT_RETRIES = 10
#     s = requests.session()
#     s.keep_alive = False
#       
#     home_page_response = requests.get(url = home_page_url, headers = headers, verify = False, timeout = 30)
#       
#     requests.DEFAULT_RETRIES = 10
#     s = requests.session()
#     s.keep_alive = False
#       
#     album_page_url_list = re.findall('<a href="(https://mrcong.com/(?!tag|sets|top3|top7|tim-kiem|huong-dan|lien-he|about-us|20|category)\S+)">', home_page_response.text)
#     album_page_url_list = list(set(album_page_url_list))
#       
#     for album_page_url in album_page_url_list :
#         print("[{0}] [page{1}] [{2}pages] [{3}]".format(count, home_page_num, len(album_page_url_list), album_page_url))
#           
#         with open(output_dir + record_album_page_url_list_filename, "a") as f:
#             text = "{0}\tpage{1}\t{2}\n".format(count, home_page_num, album_page_url)
#             f.write(text)
#             count += 1

###############################################################################################################################################
# record_album_page_url_list_content = []
#       
# record_album_page_url_list_filehandle = open(output_dir + record_album_page_url_list_filename, "r")
#       
# for line in record_album_page_url_list_filehandle.readlines() :
#     line = tuple(line.strip('\n').split('\t'))
#     record_album_page_url_list_content.append(line)
#           
# record_album_page_url_list_filehandle.close()
#       
# requests.DEFAULT_RETRIES = 10
# s = requests.session()
# s.keep_alive = False
#     
# startsite = 6041
#     
# for record_album_page_url in record_album_page_url_list_content[startsite - 1: ] :
#     count, home_page_num, album_page_url = record_album_page_url[0: 3]
#         
#     requests.packages.urllib3.disable_warnings()
#     headers["user-agent"] = random.choice(user_agent_list)
#         
#     time.sleep(random.random())
#         
#     requests.DEFAULT_RETRIES = 10
#     s = requests.session()
#     s.keep_alive = False
#         
#     album_page_response = requests.get(url = album_page_url, headers = headers, verify = False, timeout = 600)
#         
#     requests.DEFAULT_RETRIES = 10
#     s = requests.session()
#     s.keep_alive = False
#         
#     album_page_response_soup = BeautifulSoup(album_page_response.text, "html.parser")
#         
#     for k in album_page_response_soup.find_all("a"):
#         if re.search("download", str(k), flags = re.I) :
#             cloud_page_url = k.get("href")
#             if (cloud_page_url) :
#                 print("[{0}] [{1}] [{2}] [{3}]".format(count, home_page_num, album_page_url, cloud_page_url))
#                     
#                 with open(output_dir + record_cloud_page_url_list_filename, "a") as f:
#                     text = "{0}\t{1}\t{2}\t{3}\n".format(count, home_page_num, album_page_url, cloud_page_url)
#                     f.write(text)

###############################################################################################################################################
record_cloud_page_url_list_content = []
 
record_cloud_page_url_list_filehandle = open(output_dir + record_cloud_page_url_list_filename, "r")
 
for line in record_cloud_page_url_list_filehandle.readlines() :
    line = tuple(line.strip('\n').split('\t'))
    record_cloud_page_url_list_content.append(line)
        
record_cloud_page_url_list_filehandle.close()
 
requests.DEFAULT_RETRIES = 10
s = requests.session()
s.keep_alive = False
 
#startsite = 8323 + 12
startsite = 489 + 23

for record_cloud_page_url in record_cloud_page_url_list_content[startsite - 1: ] :
    count, home_page_num, album_page_url, MediaUrl = record_cloud_page_url[0: 4]
     
    url = MediaUrl
     
#    requests.packages.urllib3.disable_warnings()
    urllib3.disable_warnings()
    headers["user-agent"] = random.choice(user_agent_list)
     
#    time.sleep(random.random())
    time.sleep(5)
     
    requests.DEFAULT_RETRIES = 10
    s = requests.session()
    s.keep_alive = False
     
    req = requests.get(url, headers, verify = False)
     
    requests.DEFAULT_RETRIES = 10
    s = requests.session()
    s.keep_alive = False
     
    soup = BeautifulSoup(req.content, 'html.parser')
    url = soup.find("a", class_ = "popsok").get('href')
     
    output_filename = soup.find("div", class_ = "filename").get_text().strip("\n")
    output_detail = soup.find("ul", class_ = "details").get_text().replace("\n", "")
    output_detail = re.sub(r"Uploaded.*", "", output_detail)
     
    print("[{0}] [{1}] [{2}] [{3}]".format(count, MediaUrl, output_filename, output_detail), end = " ")
     
#    requests.packages.urllib3.disable_warnings()
    urllib3.disable_warnings()
    headers["user-agent"] = random.choice(user_agent_list)
       
#    print("[{0}]".format(headers['user-agent']), end = " ")
     
#    time.sleep(random.random())
    time.sleep(5)
     
    requests.DEFAULT_RETRIES = 10
    s = requests.session()
    s.keep_alive = False
     
    r = requests.get(url, headers, verify = False)
     
    requests.DEFAULT_RETRIES = 10
    s = requests.session()
    s.keep_alive = False
     
    with open(output_dir + soup.find("div", class_ = "filename").get_text(), 'wb') as f:
        f.write(r.content)
        print("[{0} Done...]".format(time.strftime('%m-%d %H:%M:%S', time.localtime(time.time()))))
        
    





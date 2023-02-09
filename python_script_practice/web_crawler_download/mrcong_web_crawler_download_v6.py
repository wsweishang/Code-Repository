#!/usr/bin/python3
#coding:utf-8
#2021-10-07

import os
import re
import time
import random
import requests
#import pretty_errors
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed
###############################################################################################################################################
output_dir = "D:/"
first_home_page_url = "https://mrcong.com/"
home_page_total_number = 1002
record_album_page_url_list_filename = "record_album_page_url_list.txt"
record_cloud_page_url_list_filename = "record_cloud_page_url_list_v2.txt"
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
#http://www.mediafire.com/file/re41epx6e3wfie6/YouMei_Vol.005.rar/file
MediaUrl = "http://www.mediafire.com/file/re41epx6e3wfie6/YouMei_Vol.005.rar/file"
url = MediaUrl

requests.packages.urllib3.disable_warnings()
headers["user-agent"] = random.choice(user_agent_list)

time.sleep(1)

req = requests.get(url, headers, verify = False)
soup = BeautifulSoup(req.content, 'html.parser')
url = soup.find("a", class_ = "popsok").get('href')

output_filename = soup.find("div", class_ = "filename").get_text().strip("\n")
output_detail = soup.find("ul", class_ = "details").get_text().replace("\n", "")
output_detail = re.sub(r"Uploaded.*", "", output_detail)
print("[{0}] [{1}] [{2}]".format(MediaUrl, output_filename, output_detail), end = " ")
  
time.sleep(1)

r = requests.get(url, headers, verify = False, stream = True)
file_size = int(r.headers['Content-length'])
print("[{0:.2f} MB]".format(file_size / 1024 / 1024), end = "\n")

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

def range_download(save_name, s_pos, e_pos):
#    headers = {"Range": f"bytes={s_pos}-{e_pos}"}
    headers["Range"] = f"bytes={s_pos}-{e_pos}"
    res = requests.get(url, headers, verify = False, stream = True)
    with open(save_name, "rb+") as f:
        f.seek(s_pos)
#        f.write(res.content)
        for chunk in res.iter_content(chunk_size = 64 * 1024):
            if chunk:
                f.write(chunk)


save_name = "D:/test_YouMei_Vol.005.rar"
# 先创建空文件
with open(save_name, "wb") as f:
    pass
with ThreadPoolExecutor() as p:
    futures = []
    for s_pos, e_pos in divisional_ranges:
        print(s_pos, e_pos)
        futures.append(p.submit(range_download, save_name, s_pos, e_pos))
    # 等待所有任务执行完毕
    as_completed(futures)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    









#r = requests.get(url, headers, verify = False)

# for chunk in r.iter_content(chunk_size = 512): 
#     
#     with open(output_dir + soup.find("div", class_ = "filename").get_text(), 'ab') as f:
#         f.write(chunk)
#         
# print("[{0} Done...]".format(time.strftime('%m-%d %H:%M:%S', time.localtime(time.time()))))












# with open(output_dir + soup.find("div", class_ = "filename").get_text(), 'wb') as f:
#     f.write(r.content)
#     print("[{0} Done...]".format(time.strftime('%m-%d %H:%M:%S', time.localtime(time.time()))))





# def downloadFile(name,url):
#     headers = {'Proxy-Connection': 'keep-alive'}
#     r = requests.get(url,stream=True,headers=headers)
#     length = float(r.headers['Content-length'])
#     f = open(name,'wb')
#     count = 0
#     count_tmp = 0
#     time1 = time.time()
#     for chunk in r.iter_content(chunk_size=512):
#         if chunk:
#             f.write(chunk) # 写入文件
#             count += len(chunk) #累加长度
#             #计算时间 两秒打印一次
#             if time.time() - time1 > 2:
#                 p = count / length * 100
#                 speed = (count - count_tmp) / 1024 / 1024 / 2
#                 count_tmp = count
#                 print(name + ': ' + formatFloat(p) + '%' + ' Speed: ' + formatFloat(speed) + 'M/S')
#                 time1 = time.time()
#     f.close()
# 
# 
# def formatFloat(num):
#     return '{:.2f}'.format(num)
# 
# 
# if __name__ == '__main__':
#     downloadFile('360.exe', 'http://down.360safe.com/setup.exe')



































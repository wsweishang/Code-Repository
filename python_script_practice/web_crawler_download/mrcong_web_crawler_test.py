#!/usr/bin/python3
#coding:utf-8
#2021-11-10

import re
import time
import requests
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed
###############################################################################################################################################
#http://www.mediafire.com/file/re41epx6e3wfie6/YouMei_Vol.005.rar/file
MediaUrl = "http://www.mediafire.com/file/re41epx6e3wfie6/YouMei_Vol.005.rar/file"
url = MediaUrl

headers = {}
headers["user-agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36"

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
        for chunk in res.iter_content(chunk_size = 1024): 
            if chunk:
                f.write(chunk)

save_name = "D:/test_YouMei_Vol.005.rar"
with open(save_name, "wb") as f:
    pass
with ThreadPoolExecutor() as p:
    futures = []
    for s_pos, e_pos in divisional_ranges:
        print(s_pos, e_pos)
        futures.append(p.submit(range_download, save_name, s_pos, e_pos))
    
    as_completed(futures)




















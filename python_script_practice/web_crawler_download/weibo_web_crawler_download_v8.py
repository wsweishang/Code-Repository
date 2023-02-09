#!/usr/bin/python3
#coding:utf-8
#2021-10-07

import re
import os
import random
#import urllib
import urllib.request
import time
import json
#import xlwt
###############################################################################################################################################
page_i = 104
usr_id = "5187548488"
saved_dir_path = "D:/"
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
###############################################################################################################################################
req = urllib.request.Request('https://m.weibo.cn/api/container/getIndex?type=uid&value=' + usr_id)
req.add_header("User-Agent", random.choice(user_agent_list))
data = urllib.request.urlopen(req).read().decode('utf-8', 'ignore')

containerid = ""
content = json.loads(data).get('data')
for data in content.get('tabsInfo').get('tabs') : 
    if (data.get('tab_type') == 'weibo') : 
        containerid = data.get('containerid')

usr_name = content.get('userInfo').get('screen_name')
saved_dir_path = saved_dir_path + usr_name + "_微博配图"
if not os.path.exists(saved_dir_path) :
    os.mkdir(saved_dir_path)
###############################################################################################################################################
while True : 
    weibo_url = 'https://m.weibo.cn/api/container/getIndex?type=uid&value=' + '5027511046' + '&containerid=' + containerid + '&page=' + str(page_i)
    req = urllib.request.Request(weibo_url)
    req.add_header("User-Agent", random.choice(user_agent_list))
    data = urllib.request.urlopen(req).read().decode('utf-8', 'ignore')
     
    content = json.loads(data).get('data')
    cards = content.get('cards')
     
    if (len(cards) > 0) : 
        for j in range(len(cards)) : 
            mblog = cards[j].get('mblog')
            
#            card_type = cards[j].get('card_type')
#            if (card_type == 9) : 
                
            pictures = mblog.get('pics')
            created_time = re.search(r"(\w{3}) (\w{3}) (\d{2}) (\S+) (\S+) (\d{4})", mblog.get('created_at'))
 
            if pictures : 
                for picture in pictures : 
                    pic_url = picture.get('large').get('url')
                    saved_file_name = re.search(r".*\/([^\/]+\..*)", pic_url)
                    saved_file_path = saved_dir_path + "/" + saved_file_name.group(1)
                    urllib.request.urlretrieve(pic_url, saved_file_path)
                    
                    print("[page{0}]".format(page_i), end = " ")
                    print("[{0} {1} {2}]".format(created_time[6], created_time[2], created_time[3]), end = " ")
                    print("[{0}]".format(pic_url))
                    time.sleep(1)
 
        page_i += 1
         
    else : 
        print("[Done]")
        break
###############################################################################################################################################






























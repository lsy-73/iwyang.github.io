---
title: "linux利用crontab设置定时任务"
slug: "linux-crontab"
date: 2020-08-10T18:52:25+08:00
lastmod: 2020-08-10T18:52:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["linux"]
---

## 查看定时任务

```bash
crontab -l
```

## 编辑定时任务

```bash
crontab -e
```

## 使用实例

每天，每月，每年 定时启动:

```js
每五分钟执行  */5 * * * *

每小时执行     0 * * * *

每天执行        0 0 * * *

每周执行       0 0 * * 0

每月执行        0 0 1 * *

每年执行       0 0 1 1 *
```

crontab时间举例：

```js
# 每天早上6点 
0 6 * * * echo "Good morning." >> /tmp/test.txt //注意单纯echo，从屏幕上看不到任何输出，因为cron把任何输出都email到root的信箱了。

# 每两个小时 
0 */2 * * * echo "Have a break now." >> /tmp/test.txt  

# 晚上11点到早上8点之间每两个小时和早上八点 
0 23-7/2，8 * * * echo "Have a good dream" >> /tmp/test.txt

# 每个月的4号和每个礼拜的礼拜一到礼拜三的早上11点 
0 11 4 * 1-3 command line

# 1月1日早上4点 
0 4 1 1 * command line SHELL=/bin/bash PATH=/sbin:/bin:/usr/sbin:/usr/bin MAILTO=root //如果出现错误，或者有数据输出，数据作为邮件发给这个帐号 HOME=/ 

# 每小时（第一分钟）执行/etc/cron.hourly内的脚本
01 * * * * root run-parts /etc/cron.hourly

# 每天（凌晨4：02）执行/etc/cron.daily内的脚本
02 4 * * * root run-parts /etc/cron.daily 

# 每星期（周日凌晨4：22）执行/etc/cron.weekly内的脚本
22 4 * * 0 root run-parts /etc/cron.weekly 

# 每月（1号凌晨4：42）去执行/etc/cron.monthly内的脚本 
42 4 1 * * root run-parts /etc/cron.monthly 

# 注意:  "run-parts"这个参数了，如果去掉这个参数的话，后面就可以写要运行的某个脚本名，而不是文件夹名。 　 

# 每天的下午4点、5点、6点的5 min、15 min、25 min、35 min、45 min、55 min时执行命令。 
5，15，25，35，45，55 16，17，18 * * * command

# 每周一，三，五的下午3：00系统进入维护状态，重新启动系统。
00 15 * *1，3，5 shutdown -r +5

# 每小时的10分，40分执行用户目录下的innd/bbslin这个指令： 
10，40 * * * * innd/bbslink 

# 每小时的1分执行用户目录下的bin/account这个指令： 
1 * * * * bin/account

# 每天早晨三点二十分执行用户目录下如下所示的两个指令（每个指令以;分隔）： 
203 * * * （/bin/rm -f expire.ls logins.bad;bin/expire$#@62;expire.1st）

# 每1分钟执行一次myCommand
* * * * * myCommand

# 每小时的第3和第15分钟执行
3,15 * * * * myCommand

# 在上午8点到11点的第3和第15分钟执行
3,15 8-11 * * * myCommand

# 每隔两天的上午8点到11点的第3和第15分钟执行
3,15 8-11 */2  *  * myCommand

# 每周一上午8点到11点的第3和第15分钟执行
3,15 8-11 * * 1 myCommand

# 每晚的21:30重启smb
30 21 * * * /etc/init.d/smb restart

# 每月1、10、22日的4 : 45重启smb
45 4 1,10,22 * * /etc/init.d/smb restart

# 每周六、周日的1 : 10重启smb
10 1 * * 6,0 /etc/init.d/smb restart

# 每天18 : 00至23 : 00之间每隔30分钟重启smb
0,30 18-23 * * * /etc/init.d/smb restart

# 每星期六的晚上11 : 00 pm重启smb
0 23 * * 6 /etc/init.d/smb restart

# 每一小时重启smb
* */1 * * * /etc/init.d/smb restart

# 晚上11点到早上7点之间，每隔一小时重启smb
0 23-7 * * * /etc/init.d/smb restart
```

## 参考链接

+ [1.Linux之crontab定时任务](https://blog.csdn.net/qq_22823581/article/details/80783835)
+ [2.crontab 定时任务](https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/crontab.html)
+ [3.crontab 每天，每月，每年   定时启动](https://blog.csdn.net/qq_22823581/article/details/80783835)


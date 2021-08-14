---
title: "笔记本硬盘改移动硬盘&分区安装PE"
slug: "usb3-ying-pan"
date: 2020-06-16T13:51:25+08:00
lastmod: 2020-06-16T13:51:25+08:00
draft: false
toc: false
weight: false
categories: ["技术"]
tags: ["tips"]
---

 笔记本换SSD后，原来机械硬盘没用了。这时可以将原来的硬盘改成移动硬盘。方法是买一个移动硬盘盒子。下面着重记一下在移动硬盘安装PE的方法。

1.用`DiskGenius`给移动硬盘分区：新建一个5G大小的`FAT32`格式的分区，用来安装PE；硬盘其他空间新建一个`NTFS`格式的分区，用来存放文件。

2.打开[微PE工具箱](http://www.wepe.com.cn/download.html)，右下角选择`安装PE到移动硬盘`，第一主分区选择刚才建立的`FAT32`分区，然后点击`立即安装进移动硬盘`。

3.将操作系统等相关文件复制到`FAT32`分区里，便于安装系统使用。


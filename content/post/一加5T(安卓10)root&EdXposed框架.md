---
title: "一加5T(安卓10)root&EdXposed框架"
slug: "one-plus-5T-root"
date: 2020-07-10T18:34:25+08:00
lastmod: 2020-07-10T18:34:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["tips"]
---

 首先保障手机已解锁，一加5T解锁教程：[一加5T解锁、root、刷机教程](https://www.oneplusbbs.com/forum.php?mod=viewthread&tid=3829403)

## 准备以下6个文件

注意要先把2—6号文件放在手机根目录（如果放在文件夹里，文件夹名不能有中文）。

1. 一加手机5T工具箱 _2.2.1
2. twrp-3.3.1-0-dumpling.img  （第三方recovery镜像）
3. Magisk-v20.4(20400).zip （集root管理、模块安装等功能）
4. MM管理器(叶子修改版)v1.8.zip 

<div class="note info">可在TWRP下对Magisk模块进行管理、卸载。一定要先安装这个，再安装EdXposed的两个模块，防止安装模块后手机变砖无法开机，这时就可以通过MM管理器来删除安装的模块，使用方法：在第三方rec下，点击高级→终端，输入/data/media/mm，然后回车，就可以禁用该模块了。</div>

5. Riru_(Riru_-_Core)-v21.2(35).zip和Riru_-_EdXposed-v0.4.6.1_(4510)_(YAHFA)(4510).zip （EdXposed两个模块包）

6. EdXposedManager.apk （EdXposed管理器）

## 刷入第三方recover&root

+ 打开一加手机5T工具箱，选择选项8—刷写自选Recovery，按照提示把下载好的rec拖入工具箱随后回车刷入。（如果无法拖入，直接输入rec路径即可）
+ 刷完会自动进入第三方Recovery（TWRP），这时候可以一次性选择2—5号文件刷入，当然如果只想root则只用刷入Magisk。
+ `root`后可以利用`link2sd`这个软件，冻结或者卸载系统应用，安卓10好像只能冻结，卸载不了。具体使用方法，例如：搜索更新，将自动更新冻结，以后就收不到更新了。

## 刷入EdXposed模块

选择MM管理器以及两个模块刷入。（如果模块无法刷入，可能是命名格式问题，将模块重命名为1.zip、2.zip即可，同理上面Magisk无法刷入，也重命名一下；实在不行就在`Magisk`里刷入模块）

## 安装EdXposed管理器

   重启手机安装EdXposed管理器。之后就是安装各种使用的模块了。

## 参考链接

+ [1.OnePlus 5T Android 10 root亲测教程](https://www.oneplusbbs.com/thread-5460360-1.html)
+ [2.完美支持安卓10Xposed框架★EdXposed](https://www.oneplusbbs.com/forum.php?mod=viewthread&tid=4662409)


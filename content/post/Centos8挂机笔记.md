---
title: "Centos8挂机笔记"
slug: "Centos8-gua-ji"
date: 2020-05-18T15:33:25+08:00
lastmod: 2020-05-18T15:33:25+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["服务器"]
---

接上篇[Centos8安装xfce&vnc](https://bore.vip/post/centos8-xfce-vnc/)，接下来记下，怎样在centos 服务器上挂机。

## 安装、更新firefox

### 安装firefox

```
yum install firefox -y
```

### 更新firefox

1. 用你本地的旧版 firefox，访问火狐官网，下载Linux版本的Firefox，因为我的是64位故选择的安装包是：`Firefox-latest-x86_64.tar.bz2`。
2. 进入存放下载文件（Firefox-latest-x86_64.tar.bz2）的目录。
3. 在该目录解压 Firefox-latest-x86_64.tar.bz2。

解压后会生成一个 firefox 子目录，里面有最新版本的 firefox 的二进制可执行文件，以及各种扩展模块，插件等等。

```
yum install tar -y
yum install bzip2 -y
tar -xjvf Firefox-latest-x86_64.tar.bz2
```

4. 由于有时解压后出来的文件缺少文件（原因不明），可以采用在外部解压好后，直接拷贝出firefox文件夹的方式。
5. 删除系统默认安装的旧版 firefox ，通常位于 /usr/lib64 目录下。

```
rm -rf /usr/lib64/firefox
```

6. 将当前目录下的新版 firefox 子目录复制到 /usr/lib64 目录下。

```
mv firefox /usr/lib64
```

7. 进入 /usr/bin 目录，删除其下的 firefox 脚本。

```
cd /usr/bin
rm firefox
```

8. 回到主目录或根目录，创建一个软链接，指向/usr/lib64/firefox/firefox。

```
cd
ln -s /usr/lib64/firefox/firefox /usr/bin/firefox
```

9. 查看下最新版本

```
firefox -v
```

## firefox优化

### 设置开机启动

单击桌面下面最左边的那个X一样的图标选`settings–Autostarted applications`在弹出的对话框中点击Add,在name中输`firefox`,Description不用输入，Command中输入`firefox`如此firefox的开机启动也设置好了!接下来reboot一下看看是否能正常工作!

### 设置不保存历史记录

`Edit–Preferences–Privacy` 在firefox will后面的框里选`Never remember history`，还要勾选`Delete cookies and site  data when Firefox is closed`

### 设置自动播放

依次选择`隐私和安全—Permissions—Autoplay—Allow audio and Video`

### 关闭FireFox恢复上次会话功能 

1.   在FF地址栏输入`about:config`再回车进入设置。
2. 在过滤器中输入`browser.sessionstore`查找
3.  将`browser.sessionstore.max_tabs_undo`的值改为0（把非法关闭后保存的Tab页数改为0）
4. 将`browser.sessionstore.max_windows_undo`的值改为0（把保存的窗口数改为0）
5. `browser.sessionstore.resume_from_crash`设为false（禁用恢复会话功能）
6. 关闭`about:config`页，重启firefox

现在可以测试下，打开firefox，随便打开几个网页，再用任务管理器结束firefox.exe进程，再自己启动firefox，应该看不到那恢复会话窗口了。

### 火狐禁止提交错误报告

依次选择`隐私与安全—Firefox Data Collection and Use`，取消勾选`Allow firefox to send backlogged crash reports on your behalf`

### Firefox 禁止flash崩溃提示

搜索crash  

`dom.ipc.plugins.reportCrashURL`  改为`false`

`dom.ipc.plugins.flash.subprocess.crashreporter.enabled`  改为`false`

(崩溃报告可能会占很大空间，具体方法是删除 /root/.mozilla/firefox/Crash Reports/pending 里所有文件，即删除pending文件夹，按住shift键永久删除）

### 其它

1. 解决  “Gah. Your tab just crashed error ”

`browser.tabs.remote.autostart`  设为false

## 安装配置挂机插件

### 安装插件

在火狐里安装插件。

### 配置插件

+ Start with Firefox，选择`true`
+ Auto Add Playlists，选择`true`

## 设置定时任务

```
cd /var/spool/cron 
vi root
```

```
00 00 * * * rm -rf /root/.vnc/*.log
01 00 * * * /sbin/reboot
00 06 * * * rm -rf /root/.vnc/*.log
01 06 * * * /sbin/reboot
00 12 * * * rm -rf /root/.vnc/*.log
01 12 * * * /sbin/reboot
00 18 * * * rm -rf /root/.vnc/*.log
01 18 * * * /sbin/reboot
```

## 参考链接

+ [1.centos系统crontab实现自动定时重启教程](https://www.iteye.com/blog/wangbanmin-2397404) 

+ [2.centos7 更新Firefox版本](https://cloud.tencent.com/developer/article/1406596)   



​       


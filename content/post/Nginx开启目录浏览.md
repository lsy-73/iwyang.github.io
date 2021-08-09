---
title: "Nginx开启目录浏览"
slug: "nginx-mu-lu"
date: 2020-05-24T19:51:25+08:00
lastmod: 2020-05-24T19:51:25+08:00
draft: false
toc: false
weight: false
categories: ["建站笔记"]
tags: ["nginx"]
---

 系统为centos8

 Nginx默认目录：`/usr/share/nginx/html`

Nginx主要配置文件：`/etc/nginx/nginx.conf`

```bash
vi /etc/nginx/nginx.conf
```

将下面几行配置文件加入nginx配置的server段内：

```bash
autoindex on;                        
autoindex_exact_size off;            
autoindex_localtime on;              
charset utf-8,gbk;
```

重启nginx服务：

```bash
systemctl restart nginx
```

参考链接：[centos8自定义目录安装nginx](http://www.cppcns.com/os/linux/289324.html)




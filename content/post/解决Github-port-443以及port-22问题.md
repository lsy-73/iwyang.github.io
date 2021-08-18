---
title: "解决Github Port 443以及port 22问题"
slug: ""
description: ""
date: 2021-08-18T11:56:29+08:00
lastmod: 2021-08-18T11:56:29+08:00
draft: false
toc: false
weight: false
image: ""
categories: ["技术"]
tags: ["github"]
---

 **一、解决port 443问题：**

1.切换到全：

```bash
git config --global http.proxy http://127.0.0.1:10809
 
git config --global https.proxy http://127.0.0.1:10808
```

2.取消全：

```bash
git config --global --unset http.proxy
 
git config --global --unset https.proxy
```

3.再次切换到全：

```bash
git config --global http.proxy http://127.0.0.1:10809
 
git config --global https.proxy http://127.0.0.1:10808
```

这时会出现 `port 22: Connection refused`问题。

**二、解决`port 22`问题**

1.进入.ssh的目录，使用命令`touch config`创建一个配置文件，并写入你github的配置信息。

```bash
Host github.com  
User xxxxx@xx.com  
Hostname ssh.github.com  
PreferredAuthentications publickey  
IdentityFile ~/.ssh/id_rsa  
Port 443
```

2.更改配置文件config的权限。

```bash
chmod 600 config
```

3.再尝试查看连接状态

```bash
ssh git@github.com
```

参考链接：

[1.解决 Failed to connect to github.com port 443](https://blog.csdn.net/Hodors/article/details/103226958)

[2.解决ssh: connect to host github.com port 22](https://blog.csdn.net/MBuger/article/details/70226712)


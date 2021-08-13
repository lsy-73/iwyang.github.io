---
title: "Hugo迁移笔记"
slug: "hugo-qian-yi"
date: 2020-05-15T00:19:25+08:00
lastmod: 2020-05-15T00:19:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["hugo"]
---

 首先当然是备份博客源文件。

 ## 更换服务器

参考：

+ [Hugo部署到centos —服务器操作部分](https://iwyang.gitee.io/post/hugo-install-on-centos/#%E6%9C%8D%E5%8A%A1%E5%99%A8%E6%93%8D%E4%BD%9C)
+ [Hugo部署到ubuntu —服务器操作部分](https://iwyang.gitee.io/post/hugo-install-on-ubuntu/#%E6%9C%8D%E5%8A%A1%E5%99%A8%E6%93%8D%E4%BD%9C)

## 更换电脑、重装系统

### 本地操作

参考：[hugo部署到coding—本地操作部分](https://bore.vip/post/hugo-install-on-coding/#%E6%9C%AC%E5%9C%B0%E6%93%8D%E4%BD%9C)，重新配置环境，生成公钥。

**注意最后不用初始化hugo，因为我们已经有了博客原文件了**。

### 服务器上的操作

如果是部署到服务器，先将服务器原来的SSH 公钥先删除，再上传新的SSH 公钥。具体操作如下:

服务器上输入：

```bash
su git
cd ~/.ssh
rm -rf authorized_keys
```

本地Git Bash里输入：

```javascript
ssh-copy-id -i ~/.ssh/id_rsa.pub git@服务器ip地址
```

如果在git bash中输入ssh git@服务器的IP地址,能够远程登录的话，则表示设置成功了。如若还是要输入密码，就修改目录权限：

```javascript
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### github&gitee上的操作

如果是备份源码到githuhb上，部署网页到gitee上，要将重新生成的SSH公钥添加到github&gitee上。两者都在右上角`个人设置里添加`。

### 本地最后调试

重装系统后，Algolia的自动提交索引功能要重新部署一遍，具体可查看：[Hugo添加Algolia](https://bore.vip/hugo-theme-loveit-algolia/)。最后还要在博客目录里重新关联远程仓库，还是一样先备份源码到github，再部署网页到相应服务器。

**先备份源码，再部署网页，是为了`GitInfo`以及`lastmod`能够生效和更新**，其实源码可以备份到github、gitee、coding中任意一个公开仓库都可以，当然备份到github最好。网页也无需和源码放在同一个代码托管平台上。


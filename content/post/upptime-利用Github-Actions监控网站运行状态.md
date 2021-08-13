---
title: "upptime-利用Github-Actions监控网站运行状态"
slug: "upptime-github-actions"
description: ""
date: 2021-08-02T08:05:13+08:00
lastmod: 2021-08-02T08:05:13+08:00
draft: false
toc: true
weight: false
image: ""
categories: ["技术"]
tags: ["github actions"]
---

## 创建 upptime 源

1. 进入 [upptime – GitHub](https://github.com/upptime/upptime) ，点击 Use this template。
2. Create a new repository from upptime，注意勾选`Include all branches`。
3. 进入源设置，下拉到 GitHub Pages 选项，确认 Source 已经设置为 gh-pages 分支。

## 设置 PAT

1. 新建 `Personal access token`。

+ 进入 GitHub 账户 Setttings – Developer settings – Personal access token，点击 Generate new token
+ 新建 token，权限勾选 repo 和 workflow
+ 完成后复制 token

2. 进入源的设置页面，选择 Secrets，新建 Secret。

+ 将名称设置为 `GH_PAT` 并填入 token，保存

## 配置并运行 upptime

1. 配置 upptime

+ 打开源根目录下的 .upptimerc.yml，编辑以下内容：

```yaml
# Change these first
owner: iwyang # Your GitHub organization or username, where this repository lives(更改用户名)
repo: check # The name of this repository（更改仓库名）

sites:
  - name: Bore's Notes
    url: https://bore.vip
  - name: ConstOwn
    url: https://blog.juanertu.com
  - name: 01小丁的个人博客
    url: https://tding.top
  - name: Xu's Blog
    url: https://hasaik.com
  - name: 02知行志
    url: https://baozi.fun
  - name: Takagi
    url: https://lixingyong.com
  - name: 03千与千寻
    url: https://www.chihiro.org.cn
  - name: Bill Yang's Blog
    url: https://blog.bill.moe
  - name: Sanarous's Blog
    url: https://bestzuo.cn
  - name: JACK小桔子的小屋
    url: https://jackxjz.top
  - name: 04若只如初见
    url: https://joyli.net.cn
  - name: 05大大的小蜗牛
    url: https://eallion.com

status-website:
  # Add your custom domain name, or remove the `cname` line if you don't have a domain
  # Uncomment the `baseUrl` line if you don't have a custom domain and add your repo name there
  # cname: demo.upptime.js.org （如果没有自己的域名，则注释掉cname，取消注释baseUrl）
  baseUrl: /check
  logoUrl: https://raw.githubusercontent.com/upptime/upptime.js.org/master/static/img/icon.svg
  name: Upptime
  introTitle: "**Upptime** is the open-source uptime monitor and status page, powered entirely by GitHub."
  introMessage: This is a sample status page which uses **real-time** data from our [GitHub repository](https://github.com/upptime/upptime). No server required — just GitHub Actions, Issues, and Pages. [**Get your own for free**](https://github.com/upptime/upptime)
  navbar:
    - title: Status
      href: /check  # （修改Status的url为repo的名称）
    - title: GitHub
      href: https://github.com/$OWNER/$REPO

# Upptime also supports notifications, assigning issues, and more
# See https://upptime.js.org/docs/configuration
```

![](https://cdn.jsdelivr.net/gh/iwyang/pic/20210802091341.jpg)

+ 编辑后 GItHub Actions 会自动更新 upptime 配置信息

2. 如果 upptime 没有成功运行，可以手动执行 GitHub Actions 中的 Setup 工作流。

## 效果

+ https://iwyang.github.io/check

+ https://github.com/iwyang/check

## 参考链接

+ [upptime – 利用 Github Actions 监控网站运行状态](https://azhuge233.com/upptime-%E5%88%A9%E7%94%A8-github-actions-%E7%9B%91%E6%8E%A7%E7%BD%91%E7%AB%99%E8%BF%90%E8%A1%8C%E7%8A%B6%E6%80%81/)

+ [upptime – GitHub](https://github.com/upptime/upptime)

+ [Getting started](https://upptime.js.org/docs/get-started)


---
title: "hexo利用Github Action自动构建博客"
slug: "hexo-github-action"
date: 2020-07-07T19:11:25+08:00
lastmod: 2020-07-07T19:11:25+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["hexo"]
---

## 准备两个仓库

建立两个GitHub仓库，分别叫`hexo`（私有的）和`你的GitHub用户名.github.io`（公有的）。前者用来存储博客源文件，后者用于挂载GitHub Pages。

## 准备秘钥

### 生成公钥

Windows 上安装 [Git for Windows](https://git-for-windows.github.io/) 之后在开始菜单里打开 Git Bash 输入：

```
git config --global user.name "你的用户名"
git config --global user.email "你的电子邮箱"
```

```
cd ~
mkdir .ssh
cd .ssh
ssh-keygen -t rsa
```

在系统当前用户文件夹下生成了私钥 `id_rsa` 和公钥 `id_rsa.pub`。

### 上传id_rsa.pub

在右上角个人账户依次点击`Settings`->`SSH and GPG keys`添加刚刚生成的公钥，名称随意。

### 上传id_rsa

在`hexo`源码仓库的`Settings`->`Secrets`里添加刚刚生成的私钥，名称为 `ACTION_DEPLOY_KEY`。

## 配置 GitHub Actions

在博客根目录新建`.github/workflows/gh_pages.yml`文件。代码如下：

```
name: Deploy Blog

on: [push] # 当有新push时运行

jobs:
  build: # 一项叫做build的任务

    runs-on: ubuntu-latest # 在最新版的Ubuntu系统下运行
    
    steps:
    - name: Checkout # 将仓库内master分支的内容下载到工作目录
      uses: actions/checkout@v1 # 脚本来自 https://github.com/actions/checkout
      
    - name: Use Node.js 10.x # 配置Node环境
      uses: actions/setup-node@v1 # 配置脚本来自 https://github.com/actions/setup-node
      with:
        node-version: "10.x"
    
    - name: Setup Hexo env
      env:
        ACTION_DEPLOY_KEY: ${{ secrets.ACTION_DEPLOY_KEY }}
      run: |
        # set up private key for deploy
        mkdir -p ~/.ssh/
        echo "$ACTION_DEPLOY_KEY" | tr -d '\r' > ~/.ssh/id_rsa # 配置秘钥
        chmod 600 ~/.ssh/id_rsa
        ssh-keyscan github.com >> ~/.ssh/known_hosts
        # set git infomation
        git config --global user.name 'iwyang' # 换成你自己的邮箱和名字
        git config --global user.email '455343442@qq.com'
        # install dependencies
        npm i -g hexo-cli # 安装hexo
        npm i
  
    - name: Deploy
      run: |
        # publish
        hexo generate && hexo deploy # 执行部署程序
```

## 推送到远端

### 配置Hexo的_config.yml

```
deploy:
  type: git
  repo:
    gitee: git@github.com:iwyang/iwyang.github.io.git
  branch: master
```

### 修改主题文件夹

将主题文件夹里的`.git`、`gitignore`、`.github`等文件夹都删除。

### 提交源码

今后只需备份源码到`hexo`源码分支，`gitbub action`就会自动部署博客到`iwyang.github.io`仓库。

```
git init
git remote add origin git@github.com:iwyang/hexo.git
git add .
git commit -m "备份源码"
git push --force origin master
```

## 总结

也可以只准备一个仓库`iwyang.github.io`，利用两个分支来备份。例如利用`hexo`分支备份源码，`github action`利用`master`分支部署博客。`workflows`做相应调整：

```
name: CI
on:
  push:
    branches:
      - hexo
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout source
        uses: actions/checkout@v1
        with:
          ref: hexo
      - name: Use Node.js ${{ matrix.node_version }}
        uses: actions/setup-node@v1
        with:
          version: ${{ matrix.node_version }}
      - name: Setup hexo
        env:
          ACTION_DEPLOY_KEY: ${{ secrets.ACTION_DEPLOY_KEY }}
        run: |
          mkdir -p ~/.ssh/
          echo "$ACTION_DEPLOY_KEY" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts
          git config --global user.email "455343442@qq.com"
          git config --global user.name "iwyang"
          npm install hexo-cli -g
          npm install
      - name: Hexo deploy
        run: |
          hexo clean
          hexo d
```

网上还有通过webhook来自动部署到服务器，不过还是觉得用`git hook`部署到服务器较好。

## 参考链接

+ [1.用 GitHub Actions 自动化发布Hexo网站到 GitHub Pages](https://juejin.im/post/5da03d5e6fb9a04e046bc3a2)
+ [2.GitHub Actions 自动部署 Hexo](https://segmentfault.com/a/1190000022360769)
+ [3使用 webhook 自动更新博客](https://blog.cugxuan.cn/2019/03/23/Git/Use-Webhook-To-Update-Blog/)
+ [4.Hexo使用Webhooks构建自动部署程序](https://jsonpop.cn/posts/27f296b8/)
+ [5.WebHooks](http://devgou.com/article/Git-WebHooks/)
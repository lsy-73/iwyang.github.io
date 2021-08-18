---
title: "利用github Actions自动同步项目到gitee并自动部署Gitee Pages"
slug: "github actions sync to gitee"
description: ""
date: 2021-08-17T12:06:13+08:00
lastmod: 2021-08-17T12:06:13+08:00
draft: false
toc: true
weight: false
image: ""
categories: ["技术"]
tags: ["github"]
---

## 安装GIt

本地需要安装 [Git](https://git-scm.com/) ，安装过程略。安装完git后还要配置环境变量： 右键我的电脑 –> 属性，然后点击高级系统设置 –> 环境变量 –> 选择用户变量或系统变量中的Path,点击编辑；找到Git安装目录,添加以下地址:

```bash
D:\Program Files\Git\bin
D:\Program Files\Git\mingw64\libexec\git-core
D:\Program Files\Git\mingw64\bin
```

## 生成SSH 公钥

Windows 上安装 [Git for Windows](https://git-for-windows.github.io/) 之后在开始菜单里打开 Git Bash 输入：

```bash
git config --global user.name "你的用户名"
git config --global user.email "你的电子邮箱"
```

```bash
cd ~
mkdir .ssh
cd .ssh
ssh-keygen -t rsa
```

这样就在系统当前用户文件夹下生成了私钥 `id_rsa` 和公钥 `id_rsa.pub`。

## 配置SSH 公钥

- 在 GitHub 项目的「Settings -> Secrets」路径下配置好命名为 `GITEE_RSA_PRIVATE_KEY` 和 `GITEE_PASSWORD` 的两个密钥。其中：`GITEE_RSA_PRIVATE_KEY` 存放 `id_rsa` 私钥；`GITEE_PASSWORD` 存放 `Gitee` 帐号的密码
- 在 GitHub 的个人设置页面「Settings -> SSH and GPG keys」 配置 SSH 公钥（即：id_rsa.pub），命名随意
- 在 Gitee 的个人设置页面「安全设置 -> SSH 公钥」 配置 SSH 公钥（即：id_rsa.pub），命名随意

## 配置GitHub Actions

新建文件`.github/workflows/Sync to Gitee.yml`

```yaml
name: Sync to Gitee

on:
  push:
    branches: develop

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Sync to Gitee
        uses: wearerequired/git-mirror-action@master
        env:
          # 注意在 Settings->Secrets 配置 GITEE_RSA_PRIVATE_KEY
          SSH_PRIVATE_KEY: ${{ secrets.GITEE_RSA_PRIVATE_KEY }}
        with:
          # 注意替换为你的 GitHub 源仓库地址
          source-repo: git@github.com:iwyang/iwyang.github.io.git
          # 注意替换为你的 Gitee 目标仓库地址
          destination-repo: git@gitee.com:iwyang/iwyang.git

      - name: Build Gitee Pages
        uses: yanglbme/gitee-pages-action@main
        with:
          # 注意替换为你的 Gitee 用户名
          gitee-username: iwyang
          # 注意在 Settings->Secrets 配置 GITEE_PASSWORD
          gitee-password: ${{ secrets.GITEE_PASSWORD }}
          # 注意替换为你的 Gitee 仓库，仓库名严格区分大小写，请准确填写，否则会出错
          gitee-repo: iwyang/iwyang
          # 要部署的分支，默认是 master，若是其他分支，则需要指定（指定的分支必须存在）
          branch: master
```

## 参考链接

[使用 github actions 将 github 项目自动同步到 gitee 并自动部署 Gitee Pages](https://wqdy.top/2023.html)

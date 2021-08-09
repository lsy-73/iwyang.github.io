---
title: "hexo部署到github&coding&gitee"
slug: "hexo-install-on-github-coding-and-gitee"
date: 2020-04-25T11:19:25+08:00
lastmod: 2020-04-25T11:19:25+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["hexo"]
---

## 本地操作

### 安装 Git 和 Node.js

本地需要安装 [Git](https://git-scm.com/) （ Latest source Release  2.31.1）和 [Node.js](https://nodejs.org/en/)（14.16.0 LTS），安装过程略。

安装完git后还要配置环境变量：
右键我的电脑 –> 属性，然后点击高级系统设置 –> 环境变量 –> 选择用户变量或系统变量中的Path,点击编辑；找到Git安装目录,添加以下地址:

```bash
D:\Program Files\Git\bin
D:\Program Files\Git\mingw64\libexec\git-core
D:\Program Files\Git\mingw64\bin
```

### 配置SSH 公钥

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

在系统当前用户文件夹下生成了私钥 `id_rsa` 和公钥 `id_rsa.pub`。

### 初始化 Hexo

在电脑任意目录新建一个文件夹 `hexo`，进入文件夹，在空白处点击右键选择 Git Bash，输入：

```bash
npm install -g hexo-cli
hexo init
npm install
hexo d -fg
hexo serve
```

这样便在本地初始化了 Hexo 文件夹，然后输入：
`hexo new post "第一篇文章"`
即可新建一篇文章，用文本编辑器打开 `hexo/source/_post/第一篇文章.md` 可以快速开始写作。其余使用方法和配置按照 Hexo 官网操作即可。推荐编辑器**[hexo-editor](https://github.com/zhuzhuyule/HexoEditor)**

2020/4/27更新: hexo-editor速度太慢，改用[Typora](https://www.typora.io)

### 修改 deploy 参数

打开位于 `hexo` 文件夹下的 `_config.yml`，修改 deploy 参数：

#### 单线部署

```bash
deploy:
 type: git
 repo: git@blog.yizhilee.com:hexo.git
 branch: master
```

#### 多线部署

```yaml
deploy:
  type: git
  repo:
    github: git@github.com:iwyang/iwyang.github.io.git
    coding: git@e.coding.net:iwyang/iwyang.coding.me.git
    gitee: git@gitee.com:iwyang/iwyang.git
  branch: master
```

## 部署到 GitHub

比部署到服务器要简单，这里着重讲下**绑定域名**。

### 添加解析记录

添加cname记录指向Github Pages 

| www  | CNAME | 境外 | iwyang.github.io |
| ---- | ----- | ---- | ---------------- |
| @    | CNAME | 境外 | iwyang.github.io |

这里让境外线路走github

<!-- more-->

### Github Pages 对自定义域上 Https

在GitHub pages绑定域名，**这里暂时不要勾选SSL**。

### 解决CNAME反复被删问题

> 一般我们会将Hexo博客搭建到Github上，如果在Github上为其配置一个自定义的域名时，会自动在项目仓库根目录下新添加一个`CNAME`文件。但是这里有个问题，如果将Hexo博客重新部署一遍后，Github仓库里的这个`CNAME`文件就会消失掉，又需要重新配置一遍。

**其实这里有个技巧，我们可以将需要上传部署到Github的文件都放在`source`文件夹里，例如`CNAME`文件、`favicon.ico`、或者其他的图片等等，这样在执行`hexo d`这个命令之后，这些文件就不会被删除了。 **

然后在**站点配置文件**`_config.yml`中添加`skip_render`配置：

```yaml
skip_render:
  - CNAME
```

## 部署到 coding

操作和部署到github大同小异，注意以下几点：

+ 项目地址按iwyang.coding.me来写，建议勾选“启用readme.md初始化项目”
+ 配置SSH公钥时要勾选启用推送权限。
+ 开启Coding Pages 服务，要先在`项目设置—功能开关`里开启持续集成和持续部署。然后进行实名认证：右上角—团队管理—团队设置—高级设置。
+ 删除项目，点左下角—项目设置—更多。
+ 添加自定义域名，添加cname记录，指向给你的网址。线路选默认。这样就保证国内线路走coding。
+ 注意：一定要选首选的域名，并且非首选域名要勾选跳转至首选域名，不然有些第三方服务数据会统计不到一起。
+ 开启 HTTPS，要先去域名 DNS 把 GitHub 的解析暂停掉，然后再重新申请 SSL 证书，然后开启强制 HTTPS 访问。（不然会申请失败）
+ 如果后面要用cdn全站加速，这里先不要开启ssl。

### 解决404错误

可是当你push完hexo g生成的静态页面源码到你的repo中后点Coding给你分配的访问地址后却返回的是404页面，其实解决这个问题也很简单，就是点一下上图中的立即部署就行了。

## 部署到 gitee

和部署到coding大同小异，但需要注意以下几点：

免费版gitee page不支持绑定域名、不支持自动部署，并且上传了代码服务里才有gitee pages选项。还有关于首页地址见官方文档：

>如何创建一个首页访问地址不带二级目录的 pages，如ipvb.gitee.io？

答：如果你想你的 pages 首页访问地址不带二级目录，如ipvb.gitee.io，你需要建立一个与自己个性地址同名的仓库，如 https://gitee.com/ipvb 这个用户，想要创建一个自己的站点，但不想以子目录的方式访问，想以ipvb.gitee.io直接访问，那么他就可以创建一个名字为ipvb的仓库 https://gitee.com/ipvb/ipvb 部署完成后，就可以以 https://ipvb.gitee.io 进行访问了。

## 自动部署脚本

在根目录新建`deploy.sh`，输入以下内容：

```bash
#!/bin/bash
echo -e "\033[0;32mDeploying updates to gitee...\033[0m"
hexo clean
hexo g -d
```

有时候可能需要多次运行脚本才能提交成功，这时不妨手动输入命令。

## 全站 CDN 加速

使用Cloudflare，encryption mode选 Full，在Edge Certificates选项卡开启Always Use Https

## 总结

Cloudflare+github太慢，不用多线部署，在github上绑定域名，做cname解析后，会出现问题：**即使后来github解绑域名，域名也会跳转到github 404**，直接部署到coding就好。github作镜像，不用绑定域名，不用做cname记录。

## 参考链接

+ [1.Hexo 框架 (八)：双线部署及全站 CDN 加速](https://blog.juanertu.com/archives/fde43a3f.html)

+ [2.hexo双线部署coding+github pages，实现https并开启又拍云CDN全站加速](https://blog.csdn.net/qq_41793001/article/details/102995817)

+ [3.2019hexo博客部署到coding该绕的坑-奥怪的小栈](https://aoguai.top/archives/ce8b9c09.html)
+ [4.Hexo - 解决更新网站时 Github 删除原先的自定义域名的问题](https://www.yanyunliang.com/2018/11/21/hexo-problem-with-github-deleting-the-original-custom-domain-name-when-revising-update-site.html)


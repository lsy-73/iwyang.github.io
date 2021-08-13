---
title: "Gitee+Picgo+Typecho搭建图床"
slug: "gitee-picgo-typecho"
date: 2020-06-06T08:59:25+08:00
lastmod: 2020-06-06T08:59:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["图床"]
---

## 配置gitee

### 新建公共仓库

新建一个公共仓库，例如我建的仓库地址：`https://gitee.com/iwyang/pics`，注意一定要勾选**使用Readme文件初始化这个仓库**，否则后面会无法上传图片。

### 获取私人令牌

依次点击`右上角设置—私人令牌`，在私人令牌描述中写上便于你了解该令牌用处的文字，并勾选需要的权限，PicGo要使用的私人令牌只需要`user_info`和`projects`权限，勾选上后提交，gitee将会返回私人令牌的token，保存该token，因为该token只会出现一次，离开页面过后再不会出现。

## 安装&配置PicGo

### 安装PicGo

访问[PicGo Releases](https://github.com/Molunerfinn/PicGo/releases)直接下载你的操作系统对应的安装包并完成安装。

> 注：在安装的时候安装目录千万不能选C:\Program Files\下的任何地方，因为PicGo无法解析这一路径，如果你不知道安装在哪里的话，选择仅为我安装，否则在设置Typora时会出现错误。

### 配置PicGo

在PicGo设置里作如下修改：

```bash
设置日志文件：日志记录等级选择"错误-Error"和"提醒-Warn"
时间戳重命名：开
开启上传提示：开
上传后自动复制URL：开
选择显示的图床：只勾选githubPlus
```

### 安装npm

由于PicGo的插件需要使用npm进行安装，如果你的电脑上没有安装npm，那么你是无法安装PicGo插件的，而我们接下来要使用一个额外的插件获得gitee支持，所以在此之前先完成npm的安装。访问node.js的[官网](https://nodejs.org/en/)，根据官网的指导下载并安装node.js。安装为了解决npm速度过慢问题，需更换镜像源：

```bash
npm config set registry https://registry.npm.taobao.org
```

### 安装github-plus插件

运行PicGo，单击插件设置，在搜索中输入github，安装搜索结果中的[github-plus](https://github.com/zWingz/picgo-plugin-github-plus)。

### 配置ithub-plus插件

```yaml
repo: iwyang/pics
branch: master
token: 输入私人令牌
customUrl: 不用填
origin: gitee   
```

### 上传和管理图片

+ 单击上传区，选择链接格式，使用点击上传或剪贴板图片上传，PicGo会自动上传图片并将符合链接格式的链接复制到剪贴板，你只要按下Ctrl+v即可粘贴图片的链接。

+ 单击相册，你可以看到你上传的所有图片，你可以对所有图片进行复制链接，修改图片URL与删除操作，并可以批量复制或批量删除。

要注意的是，gitee支持外部链接的文件大小限制为1M（不过我也没试过）。

## 配置Typora

+ 点击Typora左上角的文件->偏好设置

+ 在弹出的界面中点击图像，选择插入图片时选项为`上传图片`，并勾选`对本地位置的图片应用上述规则`和`对网络位置的图片应用上述规则`。
+ `上传服务`选项里选择`PicGo(app)`，`PicGo路径`选择`PicGo.exe`的绝对路径。

以后在Typora里插入本地图片时，它会利用PicGo自动帮你上传到gitee，并替换本地图片地址为gitee地址。

## 参考链接

+ [1.Gitee图床+PicGo+Typora便捷在博客中使用图片 ](https://www.cnblogs.com/focksor/p/12402471.html)

+ [2.PicGo+Gitee(码云)搭建自己的图床](https://www.jianshu.com/p/fad1dacbf535)

+ [3.手把手教你用Typora自动上传到picgo图床](https://blog.csdn.net/disILLL/article/details/104944710)


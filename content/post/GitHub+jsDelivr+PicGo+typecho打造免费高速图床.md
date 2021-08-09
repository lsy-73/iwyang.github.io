---
title: "GitHub+jsDelivr+PicGo+typecho打造免费高速图床"
slug: "github-jsDelivr-picgo-typecho"
date: 2020-07-21T16:32:25+08:00
lastmod: 2020-07-21T16:32:25+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["图床"]
---

## 配置github

### 新建公共仓库  

新建一个公共仓库，例如我建的仓库地址：`https://github.com/iwyang/pic`，注意一定要勾选**使用Readme文件初始化这个仓库**，否则后面会无法上传图片。

### 获取私人令牌

[前往设置](https://github.com/settings/tokens)，作用：授权仓库的操作权限，通过API实现自动化。然后填写 `Token` 描述，勾选 repo、write、read然后点击 `Generate token` 生成一个 `Token`。因为 Token 只会显示一次，所以先保存笔记本等。

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
选择显示的图床：只勾选Github图床
```

### 配置`GitHub`插件

安装好后开始配置`GitHub`图床

1. 设定仓库名：按照 用户名/仓库名 的格式填写（iwyang/pic）
2. 设定分支名：master
3. 设定 Token：粘贴之前叫你保存的Token。
4. 设定自定义域名：它的的作用是，在图片上传后，PicGo 会按照自定义域名+上传的图片名的方式生成访问链接，放到粘贴板上。 `https://cdn.jsdelivr.net/gh/用户名/仓库名`（`https://cdn.jsdelivr.net/gh/iwyang/pic`）

![](https://cdn.jsdelivr.net/gh/iwyang/pic/20200721164458.jpg)

### 上传和管理图片

- 单击上传区，选择链接格式，使用点击上传或剪贴板图片上传，PicGo会自动上传图片并将符合链接格式的链接复制到剪贴板，你只要按下Ctrl+v即可粘贴图片的链接。
- 单击相册，你可以看到你上传的所有图片，你可以对所有图片进行复制链接，修改图片URL与删除操作，并可以批量复制或批量删除。

## 配置Typora

- 点击Typora左上角的文件->偏好设置
- 在弹出的界面中点击图像，选择插入图片时选项为`上传图片`，并勾选`对本地位置的图片应用上述规则`和`对网络位置的图片应用上述规则`。
- `上传服务`选项里选择`PicGo(app)`，`PicGo路径`选择`PicGo.exe`的绝对路径。

以后在Typora里插入本地图片时，它会利用PicGo自动帮你上传到github，并替换本地图片地址为github地址。

## 参考链接

+ [1.GitHub + jsDelivr + PicGo 打造稳定快速、高效免费图床](https://my.oschina.net/u/3990666/blog/4371252)
+ [2.手把手教你用Typora自动上传到picgo图床](https://blog.csdn.net/disILLL/article/details/104944710)


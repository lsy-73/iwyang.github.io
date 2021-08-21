---
title: "hugo配置哔哔点啥"
slug: "hugo bber"
description: ""
date: 2021-08-17T13:45:30+08:00
lastmod: 2021-08-19T13:45:30+08:00
draft: false
toc: true
weight: false
image: ""
categories: ["技术"]
tags: ["hugo"]
---

## 服务部署

1.首先保证成功激活腾讯云开发.

2.[点击一键部署至云开发](https://console.cloud.tencent.com/tcb/env/index?action=CreateAndDeployCloudBaseProject&appUrl=https://github.com/lmm214/bber&branch=main)

> 推荐创建上海环境。如选择广州环境，需要在 twikoo.init() 时额外指定环境 region: “ap-guangzhou”

3.进入环境-登录授权，启用“匿名登录”

4.进入[环境-安全配置](https://console.cloud.tencent.com/tcb/env/safety)，将博客网址添加到“WEB安全域名”

5.进入[环境-HTTP访问服务](https://console.cloud.tencent.com/tcb/env/access)，复制链接备用。

进入[云函数](https://console.cloud.tencent.com/tcb/scf/index)，修改自定义serverkey `bber` 并保存备用。

6.进入云函数，修改自定义serverkey bber 并保存备用。

7.扫码进入公众号，输入命名绑定。

![bibi-0](https://cdn.jsdelivr.net/gh/iwyang/pic/202108171354632.jpg)

```bash
/bber 你刚刚设置的key,https://你的云函数HTTP访问地址/bber

比如: /bber mykey,https://balabala.ap-shanghai.app.tcloudbase.com/bber
```

**8. 手动添加一条哔哔 *必须要有***

进入腾讯云数据库->talks->文档列表->添加文档

```bash
字段: content
类型: string
值: 随便
```

点击确定

验证微信发送

9.微信发送一条文字，返回哔哔成功，talks文档列表里多出来一条，即为服务部署成功。

## 前端部署

1.打开Hugo的unsafe

```yaml
markup:
    tableOfContents:
        endLevel: 4
        ordered: true
        startLevel: 2
    highlight:
        noClasses: false
    goldmark:
        renderer:
            unsafe: true
```

2.新建一个*markdown*文件

```markdown
<div id='speak'></speak>
<!-- 使用markdown渲染 -->
<!-- 使用markdown渲染 -->
<!-- <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/ispeak-bber/ispeak-bber-md.min.js" charset="utf-8" ></script> -->
<!-- 不使用markdown渲染 -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/ispeak-bber/ispeak-bber.min.js" charset="utf-8" ></script>
<!-- 解析微信表情（参考：https://github.com/buddys/qq-wechat-emotion-parser） -->
<!-- <script src="https://cdn.jsdelivr.net/gh/buddys/qq-wechat-emotion-parser@master/dist/qq-wechat-emotion-parser.min.js"></script> -->
<script>
ispeakBber
    .init({
      el: '#speak', // 容器选择器
      name: 'bore', // 显示的昵称
      envId: '腾讯云开发环境id', // 环境id
      region: 'ap-shanghai', // 腾讯云地址，默认为上海
      limit: 10, // 每次加载的条数，默认为5
      avatar: 'https://cdn.jsdelivr.net/gh/iwyang/pic/avatar.jpg',
      fromColor:'rgb(245, 150, 170)', // 下方标签背景颜色 默认 rgb(245, 150, 170)
      loadingImg: 'https://7.dusays.com/2021/03/04/d2d5e983e2961.gif', // 自定义loading的图片，示例值为默认值
      dbName:'talks' // 数据的名称，默认talks，避免有人的命名不是这个，所以加入此配置字段。
    })
    .then(function() {
      // 哔哔加载完成后的回调函数，你可以写你自己的功能
      console.log('哔哔 加载完成')
    })
</script>
```
## 部署BBer-weixin公众号

点击[部署到云开发](https://console.cloud.tencent.com/tcb/env/index?action=CreateAndDeployCloudBaseProject&appUrl=https%3A%2F%2Fgithub.com%2Flmm214%2Fbber-weixin&branch=main)将 BBer-weixin 微信公众号后端，一键部署到云开发。

对接的微信公众号简要流程：

1.点击 [bber-weixin](https://console.cloud.tencent.com/tcb/scf/index) 云函数，右上角**【编辑】**，开启**【固定IP】**，留存**公网固定IP**。

> 我将from `微信公众号`改成了`💎 WeChat`

2.进入[环境-HTTP访问服务](https://console.cloud.tencent.com/tcb/env/access)，获取`触发路径链接`并留存，如以下格式：

```bash
https://bb-f5c0f-222222.ap-shanghai.app.tcloudbase.com/bber-weixin
```

3.打开 [微信公众平台](https://mp.weixin.qq.com/)，进入开发-基本配置，获取`AppID`和`AppSecret`留存，修改`IP白名单`为上一步的公网固定IP。继续服务器配置：

> 消息加密方式选择`兼容模式`

一个`URL`，即第2步留存的触发链接；

一个`Token`，预设为 `weixin`

**!!!先不点，不点，不点，不点提交！！！**

4.回 [bber-weixin](https://console.cloud.tencent.com/tcb/scf/index) 云函数，填入`微信公众号appid`、`微信公众号appsecret` 保存。

```bash
const token = 'weixin' // 微信公众号的服务器验证用的令牌 token
//填入自己的微信公众号appid和appsecret
var wxappid = '微信公众号appid',
    wxappsecret = '微信公众号appsecret',
```

5.回 [微信公众平台](https://mp.weixin.qq.com/)，提交，验证成功！

6.回 [bber-weixin](https://console.cloud.tencent.com/tcb/scf/index) 云函数，注释第44行代码，保存。

```bash
   if(tmpStr == signature){
        //请求来源鉴权
        //成功后注释下行代码
        //return event.queryStringParameters.echostr //成功后注释本行代码
        //成功后注释上行代码
```

7.手动配置或更新代码： https://github.com/lmm214/bber-weixin/tree/main/bber-weixin

## 公众号发布说说

~~接上面，部署好自己的公众号就可以用公众号发布了。这里注意利用公众号发图片。~~

1.先在公众号发一张图片

2.接着输入`/a <br>文字说明`

(输入`<br>`是为了使图片和文字不处于同一行)

注意：用公众号发图片会一连发几张，不知道是什么原因，以后就用浏览器插件发图片，注意**比例 16:9，长度568px**

## Chrome + Edge 发布说说

### 安装本地插件

[点此下载我提取并修改的浏览器插件包](https://cdn.guole.fun/others/bber%E6%B5%8F%E8%A7%88%E5%99%A8%E5%8F%91%E5%B8%83%E6%8F%92%E4%BB%B6.zip)

Chrome 安装本地插件：

访问 Chrome——更多工具——扩展程序——左上角“加载已解压的扩展程序”，选择我提供的附件，解压缩后的文件夹 1.0.0_0_Chrome，然后回到 Chrome，点开右上角`扩展程序`来固定插件。

注意：插件文件移动或丢失后，浏览器扩展失效，因为不是云端的，所以要保存在可靠路径。

### 应用商店安装插件

下载地址：[iSpeak-bber时光机](https://chrome.google.com/webstore/detail/ispeak-bber%E6%97%B6%E5%85%89%E6%9C%BA/mmehomnjakoijcfmmofbmkaigcdkkbke/related)

本地插件`from`默认为`🌈 Chrome`

## Android 捷径发布说说

从 Github 下载安装这款 “HTTP 快捷方式” apk，安装后继续下文操作。

下载地址：[HTTP-Shortcuts](https://github.com/Waboodoo/HTTP-Shortcuts/releases)

打开 HTTP 快捷方式 App，选择新建快捷方式，自定义名称、描述，在 “基本设置” 中，设置方法为 “POST” 或 “GET”，URL 为

```bash
https://你后台显示的.ap-shanghai.app.tcloudbase.com/bber?key=
```

至于 key、from，我们设置为常量，text 则设置为变量 content，每次发布的时候填写说说内容。

点击 URL 右侧的 {}，选择添加变量。常量 key 为你云函数里的 key，如果没有特别设置就是 bber。from 我们设置一个好玩的如`📱 Android 11`。添加一个变量 content。（个人觉得from直接设置为`Android`就行，不然免得以后安卓升级版本，还要跟着修改。）

接着回到 URL 页面，补充完刚才添加的常量和变量，如以下格式：

```bash
https://你后台显示的.ap-shanghai.app.tcloudbase.com/bber?key={key}&from={from}&text={content}
```

右上角，保存这个快捷方式，然后长按发送到桌面，搞定！

## 修改`ispeak-bber`样式

### 隐藏页面标题

将以下代码放在文章正文最上方。

```css
<style>
.article-header {
    display: none;
  }
</style>
```

### 修改顶部文字

自己胡乱改的，居然起了作用。不管了先用再说。

1.首先下载：[ispeak-bber-md.min.js](https://cdn.jsdelivr.net/npm/ispeak-bber/ispeak-bber-md.min.js)

2.用`Notepad++`打开，搜索`My BiBi`改成`我的说说`。

3.按F12，打开浏览器控制台，定位标题。可以发现`color: #49b1f5`前面就是标题字体大小，搜索`color: #49b1f5`，将前面的字体改成22px：`font-size: 22px`

4.接着改图标大小，一样方法定位图标，可以发现`color: black`后面就是图标大小，搜索`color: black`，将后面图标大小改成22px：`font-size: 22px`

### 修复说说出现图片时，顶部空白过大问题

搜索`white-space`作如下修改

```diff
- {\n  padding: 10px 0;\n  white-space: pre-wrap;\n}
+ {\n  padding: 0.8rem 0;\n}
```

~~注意：利用微信公众号发图片后追加文字说明，前面要加个换行符，要不然图片和文字处在同一行。~~

注意：用公众号发图片会一连发几张，不知道是什么原因，以后就用浏览器插件发图片，注意**比例 16:9，长度568px**

## 参考链接

[「哔哔点啥」微信公众号 2.0](https://immmmm.com/bb-by-wechat-pro/)

[熟悉的味道，不一样配方](https://immmmm.com/bb-talks-json/)

[手把手教你配置哔哔点啥](https://www.fanziqi.site/posts/af935eab.html)

[Android “捷径”・木木 bber 踩坑记录 + 电脑 or 手机 4 种方式直发说说](https://guole.fun/posts/bber-caikeng/)

[给 bber 换个皮肤](https://www.antmoe.com/posts/7ec820ee/)

[Hexo-Butterfly说说朋友圈适配（哔哔 for 腾讯云）自用](https://blog.zhheo.com/p/a6947667.html)

[继续折腾Hugo—看评论](https://iamlm.com/archives/keep-learning-hugo/)

[ispeak-bber](https://gitlab.com/DreamyTZK/ispeak-bber)


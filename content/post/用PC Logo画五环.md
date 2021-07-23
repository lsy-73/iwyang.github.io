---
title: "用PC Logo画五环"
slug: "pc-logo-wu-huan"
date: 2020-07-12T09:16:25+08:00
lastmod: 2020-07-12T09:16:25+08:00
draft: false
toc: false
weight: false
categories: ["学习笔记"]
tags: ["tips"]
---

 记得这是一次青年教师什么考试的题目，当然没能够做出来，有必要记录一下，代码如下：

```
cs
repeat 36+18[rt 5 fd 10 rt 5]
repeat 36+18[lt 5 fd 10 lt 5]
repeat 36[rt 5 fd 10 rt 5]
repeat 36[rt 5 fd 10 rt 5]
rt 90 repeat 36[rt 5 fd 10 rt 5]
pu bk 115 pd
repeat 36[rt 5 fd 10 rt 5]
```

参考链接：[用嵌套repeat画奥运五环 是pc logo 里的](https://zhidao.baidu.com/question/160053860.html)
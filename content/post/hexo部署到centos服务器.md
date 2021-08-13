---
title: "hexo部署到centos服务器"
slug: "hexo-install-on-centos"
date: 2020-04-25T18:37:25+08:00
lastmod: 2020-04-25T18:37:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["hexo","服务器"]
---

 服务器环境：Centos 8 x64

本地环境：Win10 x64

## 本地操作

### 安装 Git 和 Node.js

本地需要安装 [Git](https://git-scm.com/) 和 [Node.js](https://nodejs.org/en/)，安装过程略。

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

```bash
deploy:
 type: git
 repo: git@blog.yizhilee.com:hexo.git
 branch: master
```

#### 提交到github

```bash
deploy:
  type: git
  repo:
    coding: git@e.coding.net:iwyang/iwyang.coding.me.git
  branch: master
```

#### github、coding双线部署

```bash
deploy:
  type: git
  repo:
    github: git@github.com:iwyang/iwyang.github.io.git
    coding: git@e.coding.net:iwyang/iwyang.coding.me.git
  branch: master
```

#### github、coding、服务器三线线部署

```bash
deploy:
  type: git
  repo:
    github: git@github.com:iwyang/iwyang.github.io.git
    coding: git@e.coding.net:iwyang/iwyang.coding.me.git
    服务器: git@45.76.173.167:hexo.git
  branch: master
```

## 服务器操作

首先，在 服务器 上安装 Git 和 nginx。

<div class="note primary">2021.5.27 注意最好不要执行下面第一步升级操作，不然升级到最后一步会卡死，最后导致后面无法启动nginx。</div>

```bash
yum update -y
yum install git-core nginx -y
```

如果是centos 7，先要安装安装epel：`yum install epel-release`，才能安装nginx。

Nginx 安装完成后需要手动启动，启动Nginx并设置开机自启：

```bash
systemctl start nginx
systemctl enable nginx
```

如果开启了防火墙，记得添加 HTTP 和 HTTPS 端口到防火墙允许列表。

```bash
firewall-cmd --permanent --zone=public --add-service=http 
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
systemctl restart firewalld.service
```

配置完成后，访问使用浏览器服务器 ip ，如果能看到以下界面，表示运行成功。

### 配置用户

然后新增一个名为 git 的用户，过程中需要设置登录密码，输入两次密码即可。

```bash
adduser git
passwd git
```

给用户 `git` 赋予无需密码操作的权限（否则到后面 Hexo 部署的时候会提示无权限）

```bash
chmod 740 /etc/sudoers
vi /etc/sudoers
```

在图示位置`root ALL=(ALL:ALL) ALL`的下方添加

```bash
git ALL=(ALL:ALL) ALL
```

然后保存。然后更改读写权限。

```bash
chmod 440 /etc/sudoers
```

### 上传 SSH 公钥

接下来要把本地的 ssh 公钥上传到 服务器 。执行

```bash
su git
cd ~
mkdir .ssh && cd .ssh
touch authorized_keys
vi authorized_keys
```

现在要打开本地的 `Git Bash`，输入`vi ~/.ssh/id_rsa.pub`，把里面的内容复制下来粘贴到上面打开的文件里。

接着把ssh目录设置为只有属主有读、写、执行权限。代码如下：

```bash
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

然后建立放部署的网页的 Git 库。

```bash
cd ~
mkdir hexo.git && cd hexo.git
git init --bare
```

测试一下，如果在 Git Bash 中输入 `ssh git@服务器的IP地址` 能够远程登录的话，则表示设置成功了。如果你的服务器端口不是22。参考：[上传SSH公钥](https://bore.vip/archives/45284.html#%E4%B8%8A%E4%BC%A0-SSH-%E5%85%AC%E9%92%A5)。

---

ps: 如果配置完成还是提示要输入密码，可以使用 `ssh-copy-id`，在本地打开 Git Bash 输入：

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub git@服务器ip地址
```

---

### 用户授权

接下来要给用户 git 授予操作 nginx 放网页的地方的权限：

```bash
su
```

```bash
mkdir -p /var/www/hexo
chown git:git -R /var/www/hexo
```

### 配置钩子

现在就要向 Git Hooks 操作，配置好钩子：

```bash
su git
cd /home/git/hexo.git/hooks
vi post-receive
```

输入内容并保存：（里面的路径看着换吧，上面的命令没改的话也不用换）

```bash
#!/bin/bash
GIT_REPO=/home/git/hexo.git
TMP_GIT_CLONE=/tmp/hexo
PUBLIC_WWW=/var/www/hexo
rm -rf ${TMP_GIT_CLONE}
git clone $GIT_REPO $TMP_GIT_CLONE
rm -rf ${PUBLIC_WWW}/*
cp -rf ${TMP_GIT_CLONE}/* ${PUBLIC_WWW}
```

赋予可执行权限：

```bash
chmod +x post-receive
```

### 配置 nginx

然后是配置 nginx。执行

```bash
su
```

```bash
vi /etc/nginx/conf.d/hexo.conf
```

```bash
server {
  listen  80 ;
  listen [::]:80;
  root /var/www/hexo;
  server_name bore.vip www.bore.vip;
  access_log  /var/log/nginx/hexo_access.log;
  error_log   /var/log/nginx/hexo_error.log;
  error_page 404 =  /404.html;
  location ~* ^.+\.(ico|gif|jpg|jpeg|png)$ {
    root /var/www/hexo;
    access_log   off;
    expires      1d;
  }
  location ~* ^.+\.(css|js|txt|xml|swf|wav)$ {
    root /var/www/hexo;
    access_log   off;
    expires      10m;
  }
  location / {
    root /var/www/hexo;
    if (-f $request_filename) {
    rewrite ^/(.*)$  /$1 break;
    }
  }
  location /nginx_status {
    stub_status on;
    access_log off;
 }
}
```

因为放中文进去会乱码所以就不在里面注释了。代码里面配置了默认的根目录，绑定了域名，并且自定义了 404 页面的路径。
最后就重启 nginx 服务器：

```bash
systemctl restart nginx
```

---

如果上传网页后，Nginx 出现 403 Forbidden，执行：

```bash
vi /etc/selinux/config
```

将SELINUX=enforcing 修改为 SELINUX=disabled 状态。

```bash
SELINUX=disabled
```

重启生效，reboot。

---

ps: 最好做一个301跳转，把bore.vip和`www.bore.vip`合并，并把之前的域名也一并合并. 有两种实现方法,第一种方法是判断nginx核心变量host(老版本是http_host)：

```bash
server {
server_name bore.vip www.bore.vip ;
if ($host != 'bore.vip' ) {
rewrite ^/(.*)$ http://bore.vip/$1 permanent;
}
...
}
```

## 发布文章

在本地编辑好文章之后使用 `hexo g -d` ，如果hexo d后， ERROR Deployer not found: git，执行

```bash
npm install -- save hexo-deployer-git
```

## 参考链接

+ [1.在服务器上搭建hexo博客，利用git更新](https://tiktoking.github.io/2016/01/26/hexo/#)

+ [2.从 0 开始搭建 hexo 博客 ](https://eliyar.biz/how_to_build_hexo_blog/)

+ [3.基于CentOS搭建Hexo博客](https://segmentfault.com/a/1190000012907499)

+ [4.Nginx出现403 forbidden](https://blog.csdn.net/qq_35843543/article/details/81561240)
---
title: "Hugo部署到centos服务器"
slug: "hugo-install-on-centos"
date: 2020-05-13T18:05:25+08:00
lastmod: 2020-05-13T18:05:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["hugo","服务器"]
---

 服务器环境：Centos 8 x64

本地环境：Win10 x64

## 本地操作

参考：[hugo部署到coding&gitee-本地操作部分](https://bore.vip/hugo-install-on-coding-and-gitee/#1-%E6%9C%AC%E5%9C%B0%E6%93%8D%E4%BD%9C)

## 服务器操作

> **注意：这里是参照服务器搭建hexo，所以代码里hexo没有改成hugo，不过这没有任何影响**。

准备工作：如果服务器端口不是22，先要更改SSH端口，

```bash
vi /etc/ssh/sshd_config
port 22
```

然后重启生效。

首先，在服务器上安装 Git 和 nginx。

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

接下来要把本地的 ssh 公钥上传到服务器 。执行

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

测试一下，如果在 Git Bash 中输入 `ssh git@服务器的IP地址` 能够远程登录的话，则表示设置成功了。如果你的服务器端口不是22。最好像开头那样更改SSH端口。也可以参考：[上传SSH公钥](https://bore.vip/post/hugo-install-on-ubuntu-服务器/#%E4%B8%8A%E4%BC%A0-ssh-%E5%85%AC%E9%92%A5)。

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

### 修改自动部署脚本

```bash
#!/bin/bash

echo -e "\033[0;32mDeploying updates to Coding...\033[0m"

# Removing existing files
rm -rf public/*
# Build the project
hugo
# Go To Public folder
cd public
git remote rm origin
git init
git remote add origin git@你的ip:hexo.git
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master --force

# Come Back up to the Project Root
cd ..
```

或直接在`Git Bash`中手动运行以下代码：

```bash
rm -rf public/*
hugo
cd public
git remote rm origin
git init
git remote add origin git@104.224.191.88:hexo.git
git add .
git commit -m "building site"
git push origin master --force
```

## 总结

最好不要反复切换部署仓库，否则git会出现以下错误提示：

```bash
remote: error: The last gc run reported the following. Please correct the root cause
remote: and remove gc.log.
remote: Automatic cleanup will not be performed until the file is removed.
remote:
remote: warning: There are too many unreachable loose objects; run 'git prune' to remove them.
```

查资料，原来是自己本地一些 “悬空对象”太多(git删除分支或者清空stash的时候，这些其实还没有真正删除，成为悬空对象，我们可以使用merge命令可以从中恢复一些文件)

解决方法：

1.输入命令：`git fsck --lost-found`，可以看到好多“dangling commit”

2.清空他们：`git gc --prune=now`，完成

## 参考链接

+ [1.在服务器上搭建hexo博客，利用git更新](https://tiktoking.github.io/2016/01/26/hexo/#)
+ [2.从 0 开始搭建 hexo 博客](https://eliyar.biz/how_to_build_hexo_blog/)
+ [3.基于CentOS搭建Hexo博客](https://segmentfault.com/a/1190000012907499)
+ [4.Nginx出现403 forbidden](https://blog.csdn.net/qq_35843543/article/details/81561240)
+ [5.git运行突然提示 remote: error: The last gc run reported the following](https://blog.csdn.net/persist_xyz/article/details/88619036)




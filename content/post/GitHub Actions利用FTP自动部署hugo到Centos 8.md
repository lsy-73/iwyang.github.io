---
title: "GitHub Actions利用FTP自动部署hugo到Centos 8"
slug: "FTP-Deploy-GitHub-Actions-hugo"
description: ""
date: 2021-08-15T16:39:34+08:00
lastmod: 2021-08-15T16:39:34+08:00
draft: false
toc: true
weight: false
image: ""
categories: ["技术"]
tags: ["hugo","github actions","服务器"]
---

部署hugo到服务器，网上一般方法是利用`git hook`。这里记录一种新的方法：利用FTP Deploy GitHub Actions自动部署hugo到Centos8服务器。今后只要提交源码到`github`仓库，剩下的事就交给`GitHub Actions`了。

## 本地操作

参考：[hugo部署到coding&gitee&备份源码-本地操作](/archives/hugo-install-on-coding-and-gitee/#本地操作)

## 服务器操作

### 安装 Nginx

准备工作：如果服务器端口不是22，先要更改SSH端口：

```bash
vi /etc/ssh/sshd_config
port 22
```

然后重启生效。

首先，在服务器上安装`nginx`。

```bash
yum update -y
yum install nginx -y
```

如果是centos 7，先要安装安装epel：`yum install epel-release`，才能安装nginx。

### 启动 Nginx

Nginx 安装完成后需要手动启动，启动Nginx并设置开机自启：

```bash
systemctl start nginx
systemctl enable nginx
```

关闭防火墙：

```bash
systemctl stop firewalld.service
systemctl disable firewalld.service 
```

配置完成后，访问使用浏览器服务器 ip ，如果能看到以下界面，表示运行成功。

### 创建新的网站目录

Nginx 默认把网页文件存在 `/var/www/html` 目录。为了方便期间，我们在 `/var/www/` 目录下为每个站点创建一个文件夹。

```bash
sudo mkdir -p /var/www/blog
sudo chown -R $USER:$USER /var/www/blog
sudo chmod -R 755 /var/www
```

### 配置 nginx

```bash
vi /etc/nginx/conf.d/blog.conf
```

```bash
server {
  listen  80 ;
  listen [::]:80;
  root /var/www/blog;
  server_name bore.vip www.bore.vip;
  access_log  /var/log/nginx/hexo_access.log;
  error_log   /var/log/nginx/hexo_error.log;
  error_page 404 =  /404.html;
  location ~* ^.+\.(ico|gif|jpg|jpeg|png)$ {
    root /var/www/blog;
    access_log   off;
    expires      1d;
  }
  location ~* ^.+\.(css|js|txt|xml|swf|wav)$ {
    root /var/www/blog;
    access_log   off;
    expires      10m;
  }
  location / {
    root /var/www/blog;
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

重启 Nginx 服务器，使服务器设定生效：

```bash
sudo systemctl restart nginx
```

### 配置ssl证书

这里记下怎样添加 Let’s Encrypt 免费证书。（貌似只有上传了文件到网站目录，才能申请证书成功。）如果想启用阿里证书，可查看：[启用阿里免费证书](/archives/enable-ssl-on-nginx/#启用阿里免费证书)

#### 安装Certbot

```bash
yum install epel-release -y
yum install certbot -y
```

然后执行：

```bash
certbot certonly --webroot -w /var/www/blog -d bore.vip -m 455343442@qq.com --agree-tos
```

#### 配置Nginx

```bash
vi /etc/nginx/conf.d/blog.conf
```

```bash
server {
    listen 80;
    server_name bore.vip www.bore.vip;
    rewrite ^(.*)$ https://$server_name$1 permanent;
}
server {
  listen 443;
  root /var/www/blog;
  server_name bore.vip www.bore.vip;
  ssl on;
  ssl_certificate /etc/letsencrypt/live/bore.vip/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/bore.vip/privkey.pem;
  ssl_session_timeout 5m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
  ssl_prefer_server_ciphers on;
  access_log  /var/log/nginx/hexo_access.log;
  error_log   /var/log/nginx/hexo_error.log;
  error_page 404 =  /404.html;
  location ~* ^.+\.(ico|gif|jpg|jpeg|png)$ {
    root /var/www/blog;
    access_log   off;
    expires      1d;
  }
  location ~* ^.+\.(css|js|txt|xml|swf|wav)$ {
    root /var/www/blog;
    access_log   off;
    expires      10m;
  }
  location / {
    root /var/www/blog;
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

重启Nginx生效：

```bash
systemctl restart nginx
```

#### 证书自动更新

由于这个证书的时效只有 90 天，我们需要设置自动更新的功能，帮我们自动更新证书的时效。首先先在命令行模拟证书更新：

```bash
certbot renew --dry-run
```

模拟更新成功的效果如下(略)

在无法确认你的 nginx 配置是否正确时，一定要运行模拟更新命令，确保certbot和服务器通讯正常。使用 crontab -e 的命令来启用自动任务，命令行：

```bash
crontab -e
```

添加配置：（每隔两个月凌晨2:30自动执行证书更新操作）后保存退出。

```bash
30 2 * */2 * /usr/bin/certbot renew --quiet && /bin/systemctl restart nginx
```

查看证书有效期的命令：

```bash
openssl x509 -noout -dates -in /etc/letsencrypt/live/bore.vip/cert.pem
```

### 安装vsftpd

```bash
sudo yum install vsftpd -y
```

安装软件包后，启动vsftpd，并使其能够在引导时自动启动：

```bash
sudo systemctl start vsftpd
sudo systemctl enable vsftpd
```

### 配置vsftpd

```bash
vi /etc/vsftpd/vsftpd.conf
```

在`userlist_enable=YES`下面，加上：

```bash
userlist_file=/etc/vsftpd/user_list
userlist_deny=NO
```

### 创建FTP用户

创建一个新用户，名为admin:

```bash
sudo adduser admin
sudo passwd admin
```

将用户添加到允许的FTP用户列表中：

```bash
echo "admin" | sudo tee -a /etc/vsftpd/user_list
```

设置正确的权限（使ftp用户可以上传网站文件到相应目录）：

```bash
sudo chmod 755 /var/www/blog
sudo chown -R admin: /var/www/blog
```

### 关闭防火墙

```bash
systemctl stop firewalld.service
systemctl disable firewalld.service 
```

### 重启vsftpd服务

保存文件并重新启动vsftpd服务，以使更改生效：

```bash
sudo systemctl restart vsftpd
```

更多有关ftp部分可查看：[centos8搭建ftp服务器](/archives/centos8-enable-ftp/)

## Github操作

### 配置`FTP_MIRROR_PASSWORD`

点击博客仓库的Settings->Secrets->Add a new secret，Name填写`FTP_MIRROR_PASSWORD`，Value填写用户密码。

### 配置 Github actions

在博客根目录新建`.github/workflows/gh_pages.yml`文件。代码如下：

```bash
name: GitHub Page Deploy

on:
  push:
    branches:
      - develop
jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout master
        uses: actions/checkout@v2.3.4
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2.5.0
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build Hugo
        run: hugo --minify

      - name: Deploy Hugo to gh-pages
        uses: peaceiris/actions-gh-pages@v3.8.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          PUBLISH_BRANCH: master
          PUBLISH_DIR: ./public
        # cname:
        
      - name: Deploy Hugo to Server
        uses: SamKirkland/FTP-Deploy-Action@4.1.0
        with:
          server: 104.224.191.88
          username: admin
          password: ${{ secrets.FTP_MIRROR_PASSWORD }}
          local-dir: ./public/
          server-dir: /var/www/blog/
```

## 提交源码

初始化git，新建并切换到`develop`分支，将源码提交到`develop`分支。稍等片刻，github action会自动部署blog到`master`分支和服务器。

```bash
git init
git checkout -b develop
git remote add origin git@github.com:iwyang/iwyang.github.io.git
git add .
git commit -m "备份源码"
git push --force origin develop
```

最终部署脚本：

```bash
#!/bin/bash

echo -e "\033[0;32mDeploying updates to gitee...\033[0m"

# backup
git config --global core.autocrlf false
git add .
git commit -m "site backup"
git push origin develop --force
```

## 克隆源码到本地

```bash
git clone -b develop git@github.com:iwyang/iwyang.github.io.git blog --recursive
```

因为使用`Submodule`管理主题，所以最后要加上 `--recursive`，因为使用 git clone 命令默认不会拉取项目中的子模块，你会发现主题文件是空的。（另外一种方法：`git submodule init && git submodule update`）

### 同步更新源文件

```bash
git pull
```

### 同步主题文件

```bash
git submodule update --remote
```

运行此命令后， Git 将会自动进入子模块然后抓取并更新，更新后重新提交一遍，子模块新的跟踪信息便也会记录到仓库中。这样就保证仓库主题是最新的。

## 参考链接

[1.从 0 开始搭建 hexo 博客](https://eliyar.biz/how_to_build_hexo_blog/)

[2.为博客添加 Let’s Encrypt 免费证书](https://blog.yizhilee.com/post/letsencrypt-certificate/)

[3.SamKirkland](https://github.com/SamKirkland)/[FTP-Deploy-Action](https://github.com/SamKirkland/FTP-Deploy-Action)


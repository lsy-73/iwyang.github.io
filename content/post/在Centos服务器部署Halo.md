---
title: "在Centos服务器部署Halo"
slug: "centos-halo"
date: 2020-07-24T10:21:25+08:00
lastmod: 2021-07-19T10:21:25+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["halo","服务器"]
---

  本教程以 `CentOS 7.x` 为例，配置并运行 `Halo`，其他 Linux 发行版大同小异。

## 写在前面

1. 具备一定的 Linux 基础。
2. 如需域名绑定，请先保证已经正确解析 IP，以及确认服务器是否需要备案。
3. 如需使用 IP 访问，请先确保 Halo 的运行端口已经打开，除非你使用 80 端口运行 Halo。
4. 如 3 所述，如果你使用了类似 `宝塔面板` 之类的 Linux 管理面板，可能还需要在面板里设置端口。
5. 不要想当然，请严格按照文档的流程操作。

## 环境要求

为了在使用过程中不出现意外的事故，给出下列推荐的配置

- CentOS 7.x
- 512 MB 以上内存

## 服务器配置

### 更新软件包

请确保服务器的软件包已经是最新的。

```bash
sudo yum update -y
```

###  装 Java 运行环境

> 若已经存在 Java 运行环境的可略过这一步。

```bash
# 安装 OpenJRE
sudo yum install java-1.8.0-openjdk -y

# 检测是否安装成功
java -version
```

当然，这只是其中一种比较简单的安装方式，你也可以用其他方式，并不是强制要求使用这种方式安装。

## 创建 Halo 用户

我们推荐创建一个低权限的用户运行 `halo`：（这一步我没有进行，直接用root）

```bash
# 创建 halo 用户
sudo useradd -m halo
# 直接登录该用户
sudo su halo
```

## 安装 Halo

### 下载配置文件

考虑到部分用户的需要，可能需要自定义比如端口等设置项，我们提供了公共的配置文件，并且该配置文件是完全独立于安装包的。当然，你也可以使用安装包内的默认配置文件，但是安装包内的配置文件是不可修改的。请注意：配置文件的路径为 `~/.halo/application.yaml`。

```bash
# 下载配置文件到 ~/.halo 目录
curl -o ~/.halo/application.yaml --create-dirs https://dl.halo.run/config/application-template.yaml
```

### 修改配置文件

完成上一步操作，我们就可以自己配置 `Halo` 的运行端口，以及数据库相关的配置了。

```bash
# 使用 Vim 工具修改配置文件
vim ~/.halo/application.yaml
```

打开之后我们可以看到

```yaml
server:
  port: 8090

  # Response data gzip.
  compression:
    enabled: false
spring:
  datasource:
    # H2 database configuration.
    driver-class-name: org.h2.Driver
    url: jdbc:h2:file:~/.halo/db/halo
    username: admin
    password: 123456

    # MySQL database configuration.
  #    driver-class-name: com.mysql.cj.jdbc.Driver
  #    url: jdbc:mysql://127.0.0.1:3306/halodb?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
  #    username: root
  #    password: 123456

  # H2 database console configuration.
  h2:
    console:
      settings:
        web-allow-others: false
      path: /h2-console
      enabled: false

halo:
  # Your admin client path is https://your-domain/{admin-path}
  admin-path: admin

  # memory or level
  cache: memory
```

1. 如果需要自定义端口，修改 `server` 节点下的 `port` 即可。
2. 默认使用的是 `H2 Database` 数据库，这是一种嵌入式的数据库，使用起来非常方便。需要注意的是，默认的用户名和密码为 `admin` 和 `123456`，这个是自定义的，最好将其修改，并妥善保存。
3. 如果需要使用 `MySQL` 数据库，需要将 `H2 Database` 的所有相关配置都注释掉，并取消 `MySQL` 的相关配置。另外，`MySQL` 的默认数据库名为 `halodb`，请自行配置 `MySQL` 并创建数据库，以及修改配置文件中的用户名和密码。
4. `h2` 节点为 `H2 Database` 的控制台配置，默认是关闭的，如需使用请将 `h2.console.settings.web-allow-others` 和 `h2.console.enabled` 设置为 `true`。控制台地址即为 `域名/h2-console`。注意：非紧急情况，不建议开启该配置。
5. `server.compression.enabled` 为 `Gzip` 功能配置，如有需要请设置为 `true`，需要注意的是，如果你使用 `Nginx` 或者 `Caddy` 进行反向代理的话，默认是有开启 `Gzip` 的，所以这里可以保持默认。
6. `halo.admin-path` 为后台管理的根路径，默认为 `admin`，如果你害怕别人猜出来默认的 `admin`（就算猜出来，对方什么都做不了），请自行设置。仅支持一级，且前后不带 `/`。
7. `halo.cache` 为系统缓存形式的配置，可选 `memory` 和 `level`，默认为 `memory`，将数据缓存到内存，使用该方式的话，重启应用会导致缓存清空。如果选择 `level`，则会将数据缓存到磁盘，重启不会清空缓存。如不知道如何选择，建议默认。

注意：使用 MySQL 之前，必须要先新建一个 `halodb` 数据库，MySQL 版本需 5.7 以上。

```sql
create database halodb character set utf8mb4 collate utf8mb4_bin;
```



### 运行 Halo

Halo 的整个应用程序只有一个 Jar 包，且不包含用户的任何配置，它放在任何目录都是可行的。需要注意的是，Halo 的整个额外文件全部存放在 `~/.halo` 目录下，包括 `application.yaml（用户配置文件）`，`template/themes（主题目录）`，`upload（附件上传目录）`，`halo.db.mv（数据库文件）`。一定要保证 `~/.halo` 的存在，你博客的所有资料可都存在里面。所以你完全不需要担心安装包的安危，它仅仅是个服务而已。

访问[GitHub release](https://github.com/halo-dev/halo/releases)，下载最新稳定版本。

```bash
# 下载最新的 Halo 安装包，{{version}} 为版本号，不带 v，更多下载地址请访问 https://halo.run/archives/download.html
wget https://dl.halo.run/release/halo-{{version}}.jar -O halo-latest.jar

# 启动测试
java -jar halo-latest.jar
```

如看到以下日志输出，则代表启动成功.

```bash
run.halo.app.listener.StartedListener    : Halo started at         http://127.0.0.1:8090
run.halo.app.listener.StartedListener    : Halo admin started at   http://127.0.0.1:8090/admin
run.halo.app.listener.StartedListener    : Halo has started successfully!
```

提示：以上的启动仅仅为测试 Halo 是否可以正常运行，如果我们关闭 ssh 连接，Halo 也将被关闭。要想一直处于运行状态，请继续看下面的教程。

### 进阶配置

上面我们已经完成了 Halo 的整个配置和安装过程，接下来我们对其进行更完善的配置，比如：`需要开机自启？`，`更简单的启动方式？`

实现以上功能我们只需要新增一个配置文件即可，也就是使用 `Systemd` 来完成这些工作。

如果当前用户为 halo 用户，则需要退出 halo 用户，进入一个拥有管理员权限的用户下：

```bash
# 查看当前登录用户
whoami

# 退出 halo 登录，进入一个有管理员权限的用户
su xxx 或者直接 exit
# 下载 Halo 官方的 halo.service 模板
sudo curl -o /etc/systemd/system/halo.service --create-dirs https://dl.halo.run/config/halo.service
```

下载完成之后，我们还需要对其进行修改。

```bash
# 修改 halo.service
sudo vim /etc/systemd/system/halo.service
```

打开之后我们可以看到

```conf
[Unit]
Description=Halo Service
Documentation=https://halo.run
After=network-online.target
Wants=network-online.target

[Service]
User=halo
Type=simple
ExecStart=/usr/bin/java -server -Xms256m -Xmx256m -jar YOUR_JAR_PATH
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
StandOutput=syslog

StandError=inherit

[Install]
WantedBy=multi-user.target
```

参数：

- -Xms256m：为 JVM 启动时分配的内存，请按照服务器的内存做适当调整，512 M 内存的服务器推荐设置为 128，1G 内存的服务器推荐设置为 256，默认为 256。
- -Xmx256m：为 JVM 运行过程中分配的最大内存，配置同上。
- YOUR_JAR_PATH：Halo 安装包的绝对路径，例如 `/www/wwwroot/halo-latest.jar`。

提示：

1. 如果你不是按照上面的方法安装的 JDK，请确保 `/usr/bin/java` 是正确无误的。
2. systemd 中的所有路径均要写为绝对路径，另外，`~` 在 systemd 中也是无法被识别的，所以你不能写成类似 `~/halo-latest.jar` 这种路径。
3. 如何检验是否修改正确：把 ExecStart 中的命令拿出来执行一遍。

```bash
# 修改 service 文件之后需要刷新 Systemd
sudo systemctl daemon-reload

# 使 Halo 开机自启
sudo systemctl enable halo

# 启动 Halo
sudo service halo start

# 重启 Halo
sudo service halo restart

# 停止 Halo
sudo service halo stop

# 查看 Halo 的运行状态
sudo service halo status
```

完成以上操作即可通过 `IP:端口` 访问了。不过在此之前，最好先完成后续操作，我们还需要让域名也可以访问到 Halo，请继续看 [配置域名访问](https://halo.run/archives/install-reverse-proxy.html)。

### 更新 Halo

```bash
# 备份数据
cp -r ~/.halo ~/.halo.bak

# 备份旧的安装包
mv halo-latest.jar halo-latest.jar.bak

# 下载最新的 Halo 安装包，{{version}} 为版本号，不带 v，更多下载地址请访问 https://halo.run/archives/download.html
wget https://dl.halo.run/release/halo-{{version}}.jar -O halo-latest.jar

# 测试是否能够正常启动
java -jar halo-latest.jar

# 重启应用
service halo restart
```

<div class="note info">更新halo后可能会出现502 Bad Gateway错误，这时候首先要清空浏览器缓存，然后多刷新几次就行了。</div>

## 配置域名访问

1. 假设你已经成功配置并运行好了 Halo，且不是使用 80 端口运行。
2. 请确保域名已经成功解析到服务器 IP，并确认服务器是否需要备案。
3. 请检查服务器的 80 和 443 端口是否开放。
4. 如 3 所述，如果你使用了类似 `宝塔面板` 之类的 Linux 管理面板，可能还需要在面板里设置端口。
5. 并不一定要求按照下列教程操作，这里仅仅以供参考。
6. 如 2 所述，你需要做的仅仅是反向代理 Halo 运行端口，并配置 SSL 证书而已，所以并不要求配置方式。

### 使用 Nginx 进行反向代理

我使用的是这一种方法。

#### 安装 Nginx

```bash
# 添加 Nginx 源
sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

# 安装 Nginx
sudo yum install -y nginx

# 启动 Nginx
sudo systemctl start nginx.service

# 设置开机自启 Nginx
sudo systemctl enable nginx.service
```

#### 配置 Nginx

```bash
# 下载 Halo 官方的 Nginx 配置模板
curl -o /etc/nginx/conf.d/halo.conf --create-dirs https://dl.halo.run/config/nginx.conf
```

下载完成之后，我们还需要对其进行修改

```bash
# 使用 vim 编辑 halo.conf
vim /etc/nginx/conf.d/halo.conf
```

打开之后我们可以看到

```nginx
server {
    listen 80;

    server_name example.com www.example.com;

    location / {
        proxy_set_header HOST $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_pass http://127.0.0.1:8090/;
    }
}
```

> 注意：请把 `example.com` 改为自己的域名。

修改完成之后

```bash
# 检查配置是否有误
sudo nginx -t

# 重载 Nginx 配置
sudo nginx -s reload
```

#### 配置 SSL 证书

在这里我只演示如果自动申请证书，如果你自己准备了证书，请查阅相关教程。

```bash
# 先安装epel:
sudo yum install epel-release -y

# 安装 certbot 以及 certbot nginx 插件
sudo yum install certbot python2-certbot-nginx -y

# 执行配置，中途会询问你的邮箱，如实填写即可
sudo certbot --nginx

# 自动续约
sudo certbot renew --dry-run
```

到这里，关于 Nginx 的配置也就完成了，现在你可以访问一下自己的域名，并进行 Halo 的初始化了。

在设置了反向代理之后，请一定记得去 Halo 的管理端设置一下正确的博客地址，否则可能会造成资源获取不成功。

#### 添加 Let’s Encrypt 免费证书

可以利用前面《Nginx配置ssl证书》的方法申请证书，然后更改：

```bash
server {
    listen 80;
    server_name blog.bore.vip;
    rewrite ^(.*)$ https://$host$1 permanent;

    client_max_body_size 1024m;
}
server {
    listen 443 ssl;
    server_name blog.bore.vip;
    ssl_certificate /etc/letsencrypt/live/blog.bore.vip/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/blog.bore.vip/privkey.pem;
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_set_header HOST $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_pass http://127.0.0.1:8090/;
    }
}
```

不过这样的话，无法自动更新证书，得把nginx配置文件改回原来再申请证书，申请成功后再改过来。（突然发现使用`certbot certonly --webroot -w /var/www/hugo -d blog.bore.vip -m 455343442@qq.com --agree-tos`可以重新申请证书了，也许证书到期直接可以运行此命令来重新申请证书，不用再改`nginx`配置文件了。此前不能用此命令申请证书，所以将申请证书的目录克隆了一份hugo网页，证书才申请成功。）

#### 使用阿里云免费证书

```yaml
server {
    listen 80;
    server_name iwyang.xyz;
    rewrite ^(.*)$ https://$host$1 permanent;

    client_max_body_size 1024m;
}
server {
    listen 443 ssl;

    server_name iwyang.xyz;

    ssl_certificate /etc/nginx/cert/iwyang.xyz.pem;
    ssl_certificate_key /etc/nginx/cert/iwyang.xyz.key;
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_set_header HOST $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_pass http://127.0.0.1:8090/;
    }
}
```

### 或者使用 Caddy 进行反向代理

`Caddy` 是一款使用 `Go` 语言开发的 `Web` 服务器。其配置更为简洁，并可以自动申请及配置 SSL 证书。

#### 安装 Caddy

```bash
# 安装 Caddy 软件包
yum install epel-release -y
yum install caddy -y
```

#### 配置 Caddy

```bash
# 下载 Halo 官方的 Caddy 配置模板
curl -o /etc/caddy/conf.d/Caddyfile.conf --create-dirs https://dl.halo.run/config/Caddyfile
```

下载完成之后，我们还需要对其进行修改。

```bash
# 使用 vim 编辑 Caddyfile
vim /etc/caddy/conf.d/Caddyfile.conf
```

打开之后我们可以看到

```nginx
https://www.simple.com {
 gzip
 tls xxxx@xxx.xx
 proxy / localhost:port {
  transparent
 }
}
```

1. 请把 `https://www.simple.com` 改为自己的域名。
2. `tls` 后面的 `xxxx@xxx.xx` 改为自己的邮箱地址，这是用于自动申请 SSL 证书用的。需要注意的是，不需要你自己配置 SSL 证书，而且会自动帮你续签。
3. `localhost:port` 请将 `port` 修改为 Halo 的运行端口，默认为 8090。

修改完成之后启动 `Caddy` 服务即可。

```bash
# 开启自启 Caddy 服务
systemctl enable caddy

# 启动 Caddy
service caddy start

# 停止运行 Caddy
service caddy stop

# 重启 Caddy
service caddy restart

# 查看 Caddy 运行状态
service caddy status
```

如果 Caddy 启动出现诸如 `[/usr/lib/systemd/system/caddy.service:23] Unknown lvalue 'AmbientCapabilities' in section 'Service'` 这样的问题，请使用 `yum update -y` 更新系统。然后再使用 `service caddy restart` 重启，已知 `CentOS 7.3` 会出现该问题。

#### 进阶设置

多网址重定向到主网址，比如访问 `simple.com` 跳转到 `www.simple.com` 应该怎么做呢？

```bash
# 使用 vim 编辑 Caddyfile
vim /etc/caddy/conf.d/Caddyfile.conf
```

打开之后我们在原有的基础上添加以下配置

```nginx
https://simple.com {
  redir https://www.simple.com{url}
}
```

将 `https://simple.com` 和 `https://www.simple.com{url}` 修改为自己需要的网址就行了，比如我要求访问 `ryanc.cc` 跳转到 `www.ryanc.cc`，完整的配置如下：

```nginx
https://ryanc.cc {
  redir https://www.ryanc.cc{url}
}

https://www.ryanc.cc {
  gzip
  tls i@ryanc.cc
  proxy / localhost:8090 {
    transparent
  }
}
```

最后我们重启 `Caddy` 即可。

到这里，关于 `Caddy` 反向代理的配置也就完成了，现在你可以访问一下自己的域名，并进行 `Halo` 的初始化了。

在设置了反向代理之后，请一定记得去 Halo 的管理端设置一下正确的博客地址，否则可能会造成资源获取不成功。

## halo更改评论模块

首先进入后台，依次点击：`系统`—`博客设置`—`评论设置`，更改`评论模块JS`。系统默认（halo 1.3.2）`评论模块JS`为：

```bash
//cdn.jsdelivr.net/npm/halo-comment@latest/dist/halo-comment.min.js
```

更改为[halo-comment-fly](https://github.com/halo-dev/halo-comment-fly)评论模块JS：

```bash
https://cdn.jsdelivr.net/gh/hshanx/halo-comment-fly@latest/dist/halo-comment.min.js
```

或者：

```bash
https://cdn.jsdelivr.net/gh/hshanx/halo-comment-hshan@2.0.6/dist/halo-comment.min.js
```

更多`评论模块JS`，可以在`github`中搜索[halo comment](https://github.com/search?q=halo+comment)。

## 定时删除halo日志

```bash
crontab -e
```

```bash
0 0 * * * rm -rf /root/.halo/logs/*
```

意思是每天删除日志文件。

## 参考链接

+ [1.在 Linux 服务器部署 Halo](https://halo.run/archives/install-with-linux.html)
+ [2.配置域名访问](https://halo.run/archives/install-reverse-proxy.html)
+ [3.CentOS 7 Nginx配置Let's Encrypt SSL证书](https://juejin.im/entry/5b59c3f26fb9a04fda4e2238)


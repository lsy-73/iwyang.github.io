---
title: "Nginx配置ssl证书"
slug: "enable-ssl-on-nginx"
date: 2020-05-14T10:07:25+08:00
lastmod: 2021-07-18T10:07:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["nginx"]
---

## 启用阿里免费证书

### 申请证书

查看：[申请免费DV试用证书](https://help.aliyun.com/document_detail/156645.html)


### 安装证书

基本操作参考：[在Nginx/Tengine服务器上安装证书](https://help.aliyun.com/document_detail/98728.html?spm=5176.2020520163.cas.13.6053jBDQjBDQPD)，这里具体讲下Nginx上的配置。

1.在nginx根目录（默认为/etc/nginx）下创建目录cert。

```bash
cd /etc/nginx
mkdir cert
```

2.把下载的证书两个文件.pem和.key上传到目录cert中。

3.修改nginx配置文件。`vi /etc/nginx/conf.d/hexo.conf`

```bash
server {
    listen 80;
    server_name bore.vip www.bore.vip;
    rewrite ^(.*)$ https://$server_name$1 permanent;
}
server {
   listen 443;
  root /var/www/hexo;
  server_name bore.vip www.bore.vip;
  ssl on;
  ssl_certificate /etc/nginx/cert/xxxx.pem;
  ssl_certificate_key /etc/nginx/cert/xxxx.key;
  ssl_session_timeout 5m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
  ssl_prefer_server_ciphers on;
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

4.修改hugo站点配置文件_config.toml

`baseURL = "https://bore.vip/"`

5.开启负载均衡

在阿里云[SSl证书控制台](https://yundunnext.console.aliyun.com/?spm=a2c4g.11186623.2.13.775345eav2PxV4&p=cas#/overview/cn-hangzhou)，依次选择`部署—负载均衡—选择所有区域`，然后部署。

6.重启nginx服务。

ubuntu、centos 6

`/etc/init.d/nginx restart`

centos 7、8

```bash
systemctl restart nginx
```

## 添加 Let's Encrypt 免费证书

### Ubuntu上的操作

#### 安装 Certbot

在 Ubuntu 上只需要简单的一行命令：

`sudo apt-get install letsencrypt`

其他的发行版可以在[这里](https://certbot.eff.org/)选择。

#### 使用 webroot 自动生成证书

Certbot 支持多种不同的「插件」来获取证书，这里选择使用 [webroot](https://certbot.eff.org/docs/using.html#webroot) 插件，它可以在不停止 Web 服务器的前提下自动生成证书，使用 `--webroot` 参数指定网站的根目录。

`letsencrypt certonly --webroot -w /var/www/hexo -d iwyang.top`

这样，在 /var/www/hexo 目录下创建临时文件 .well-known/acme-challenge ，通过这个文件来证明对域名 iwyang.top 的控制权，然后 Let’s Encrypt 验证服务器发出 HTTP 请求，验证每个请求的域的 DNS 解析，验证成功即颁发证书。

生成的 pem 和 key 在 `/etc/letsencrypt/live/` 目录下

>cert.pem 用户证书
>chain.pem 中间证书
>fullchain.pem 证书链, chain.pem + cert.pem
>privkey.pem 证书私钥

`

#### 自动续期

Let’s Encrypt 的证书有效期为 90 天，不过我们可以通过 crontab 定时运行命令更新证书。

先运行以下命令来测试证书的自动更新：

`letsencrypt renew --dry-run --agree-tos`

如果一切正常，就可以编辑 crontab 定期运行以下命令：

```bash
crontab -e
* 2 * * * service nginx stop & letsencrypt renew & service nginx start
```

#### 配置 Nginx

修改 Nginx 配置文件中关于证书的配置：

```bash
vi /etc/nginx/conf.d/hexo.conf
```

```bash
server {
    listen 80;
    server_name iwyang.top www.iwyang.top;
    rewrite ^(.*)$ https://$server_name$1 permanent;
}
server {
   listen 443;
  root /var/www/hexo;
  server_name iwyang.top www.iwyang.top;
  ssl on;
  ssl_certificate /etc/letsencrypt/live/iwyang.top/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/iwyang.top/privkey.pem;
  ssl_session_timeout 5m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
  ssl_prefer_server_ciphers on;
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

然后重启 Nginx ，应该就可以看到小绿标了。`/etc/init.d/nginx restart`

### Centos 8上的操作

#### 安装Certbot

```bash
yum install epel-release -y
yum install certbot -y
```

然后执行：

```bash
certbot certonly --webroot -w /var/www/hexo -d bore.vip -m 455343442@qq.com --agree-tos
```

#### 配置Nginx

顶级域名参考上面Ubuntu Nginx的配置，二级域名操作如下：

```bash
vi /etc/nginx/conf.d/hexo.conf
```


```bash
server {
    listen 80;
    server_name bore.vip www.bore.vip;
    rewrite ^(.*)$ https://$server_name$1 permanent;
}
server {
  listen 443;
  root /var/www/hexo;
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

重启Nginx生效：

```bash
systemctl restart nginx
```

#### 证书自动更新

由于这个证书的时效只有 90 天，我们需要设置自动更新的功能，帮我们自动更新证书的时效。首先先在命令行模拟证书更新：

```bash
certbot renew --dry-run
```

模拟更新成功的效果如下：

```bash
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates below have not been saved.)
## 可以看到两个域名续期成功
The following certs were successfully renewed:
  /etc/letsencrypt/live/blog.bore.vip/fullchain.pem (success)
  /etc/letsencrypt/live/f.bore.vip/fullchain.pem (success)
## 以下失败的一个域名不用管
The following certs could not be renewed:
  /etc/letsencrypt/live/novel.bore.vip/fullchain.pem (failure)
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates above have not been saved.)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

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

## 参考链接

+ [1.在Nginx/Tengine服务器上安装证书](https://help.aliyun.com/document_detail/98728.html?spm=5176.2020520163.cas.13.6053jBDQjBDQPD)
+ [2.阿里云hexo站点https之nginx配置](https://www.ratel.net.cn/2019/07/18/%E9%98%BF%E9%87%8C%E4%BA%91hexo%E7%AB%99%E7%82%B9https%E4%B9%8Bnginx%E9%85%8D%E7%BD%AE/)
+ [3.为博客添加 Let's Encrypt 免费证书 ](https://blog.yizhilee.com/post/letsencrypt-certificate/)
+ [4.ubuntu 生成https证书 for let's encrypt](https://www.cnblogs.com/gabin/p/6844481.html)
+ [5.Ubuntu 16设置定时任务](https://blog.csdn.net/a295277302/article/details/78143010)
+ [6.Ubuntu查看crontab运行日志](https://blog.csdn.net/zhuangtim1987/article/details/52280409)
+ [7.Let's Encrypt证书自动更新](https://blog.csdn.net/shasharoman/article/details/80915222)
+ [8.CentOS 7 Nginx配置Let's Encrypt SSL证书](https://juejin.im/entry/5b59c3f26fb9a04fda4e2238)


---
title: "centos8搭建ftp服务器"
slug: "centos8-enable-ftp"
date: 2020-06-06T19:34:25+08:00
lastmod: 2020-06-06T19:34:25+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["服务器"]
---

## 安装vsftpd

```
sudo yum install vsftpd -y
```

安装软件包后，启动vsftpd，并使其能够在引导时自动启动：

```
sudo systemctl start vsftpd
sudo systemctl enable vsftpd
```

## 配置vsftpd

```
vi /etc/vsftpd/vsftpd.conf
```

要仅允许某些用户登录FTP服务器，需要在`userlist_enable=YES`下面，加上：

```
userlist_file=/etc/vsftpd/user_list
userlist_deny=NO
```

启用此选项后，您需要通过将用户名添加到`/etc/vsftpd/user_list`文件（每行一个用户）来明确指定哪些用户可以登录。

完成编辑后，vsftpd配置文件应如下所示：

```
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
#anon_upload_enable=YES
#anon_mkdir_write_enable=YES
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
#chown_uploads=YES
#chown_username=whoever
#xferlog_file=/var/log/xferlog
xferlog_std_format=YES
#idle_session_timeout=600
#data_connection_timeout=120
#nopriv_user=ftpsecure
#async_abor_enable=YES
#ascii_upload_enable=YES
#ascii_download_enable=YES
#ftpd_banner=Welcome to blah FTP service.
#deny_email_enable=YES
#banned_email_file=/etc/vsftpd/banned_emails
#chroot_local_user=YES
#chroot_list_enable=YES
#chroot_list_file=/etc/vsftpd/chroot_list
#ls_recurse_enable=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
userlist_file=/etc/vsftpd/user_list
userlist_deny=NO
```

## 重启vsftpd服

保存文件并重新启动vsftpd服务，以使更改生效：

```
sudo systemctl restart vsftpd
```

## 设置防火墙

最直接方法关闭防火墙。

## 创建FTP用户

创建一个新用户，名为admin:

```
sudo adduser admin
sudo passwd admin
```

将用户添加到允许的FTP用户列表中：

```
echo "admin" | sudo tee -a /etc/vsftpd/user_list
```

设置正确的权限：

```
sudo chmod 750 /home/admin
sudo chown -R admin: /home/admin
```

如果遇到文件无法下载，可能需要更改文件所属用户组，例如：

```
chown admin 文件名
```

## 参考链接

+ [1.如何在CentOS 7上使用VSFTPD设置FTP服务器](https://www.myfreax.com/how-to-setup-ftp-server-with-vsftpd-on-centos-7/)

+ [2.基于 CentOS 搭建 FTP 文件服务](https://blog.csdn.net/zyw_java/article/details/75212608)

